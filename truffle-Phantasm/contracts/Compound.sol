// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import './interfaces/ICompound.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './interfaces/swapImplementation.sol';


contract CompoundImplementation {
    
    Comptroller public comptroller = Comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
    PriceFeed public priceFeed = PriceFeed(0x922018674c12a7F0D394ebEEf9B58F186CdE13c1);
    IERC20 public WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 public dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    CErc20 public cDai = CErc20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    IERC20 public token;
    CErc20 public cToken;
    IERC20 public tokenBorrow;
    CErc20 public cTokenBorrow;
    uint256 public cTokenBorrowDecimals;


    constructor (address _token, address _cToken, address _tokenBorrow, address _cTokenBorrow, uint256 _cTokenBorrowDecimals) {
        token = IERC20(_token);
        cToken = CErc20(_cToken);

        tokenBorrow = IERC20(_tokenBorrow);
        cTokenBorrow = CErc20(_cTokenBorrow);
        cTokenBorrowDecimals = _cTokenBorrowDecimals;
    }

    receive() external payable {}

    /*
    ░█▀▀█ █▀▀█ ─▀─ █▀▄▀█ █▀▀█ █▀▀█ █──█ 　 ░█▀▀▀ █──█ █▀▀▄ █▀▀ ▀▀█▀▀ ─▀─ █▀▀█ █▀▀▄ █▀▀ 
    ░█▄▄█ █▄▄▀ ▀█▀ █─▀─█ █▄▄█ █▄▄▀ █▄▄█ 　 ░█▀▀▀ █──█ █──█ █── ──█── ▀█▀ █──█ █──█ ▀▀█ 
    ░█─── ▀─▀▀ ▀▀▀ ▀───▀ ▀──▀ ▀─▀▀ ▄▄▄█ 　 ░█─── ─▀▀▀ ▀──▀ ▀▀▀ ──▀── ▀▀▀ ▀▀▀▀ ▀──▀ ▀▀▀
    */


    function openPosition(address _borrowToken, address _borrowCToken, uint256 initialAmount, uint256 _borrowFactor) internal virtual {
        uint256 nextCollateralAmount = initialAmount;
        for(uint i = 0; i < 5; i++) {
            nextCollateralAmount = addCollateral(_borrowToken, _borrowCToken, nextCollateralAmount, _borrowFactor);
        }
    }

    function addCollateral(address _borrowToken, address _borrowCToken, uint256 _collateralAmount, uint256 _borrowFactor) internal virtual  returns(uint256) {
        IERC20(_borrowToken).approve(_borrowCToken, _collateralAmount);
        CErc20(_borrowCToken).mint(_collateralAmount);
        uint borrowAmount = (_collateralAmount * _borrowFactor) / 100;
        // Borrow
        require(CErc20(_borrowCToken).borrow(borrowAmount) == 0, "borrow failed");
        return borrowAmount;
    }

    function closePosition(address _borrowedToken, address _borrowedCToken, address _collateralCToken, uint256 _debt, uint256 _value, address _recipient) external virtual  {
        // Closing position will Usually take Dai and cDai Addresses for _borrowedToken and _borrowedCToken values respectively

        IERC20(_borrowedToken).approve(_borrowedCToken, _value);
        CErc20(_borrowedCToken).repayBorrow(_debt);
        CErc20(_collateralCToken).redeem(_value);
        IERC20(_borrowedToken).transfer(_recipient, _value);
    }

    /*
    ░█▀▀█ █▀▀█ █▀▀█ █▀▀ █▀▀ █▀▀ █▀▀ 
    ░█▄▄█ █▄▄▀ █──█ █── █▀▀ ▀▀█ ▀▀█ 
    ░█─── ▀─▀▀ ▀▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀
    */
    struct Position {
        bool    isLong;
        address asset;
        address stablecoin;
        uint256 debtOwed;
        uint256 valueRetained;
        uint64 _lender;
    }

    function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external virtual {
        openPosition(address(dai), address(cDai), _borrowAmount, _borrowFactor);

        uint256 bal = dai.balanceOf(address(this));
        uint256 _amountOutMin = swapImplementation(_swapImplementation)._getAmountOutMin(address(dai), _longToken, bal);
        swapImplementation(_swapImplementation).swap(address(dai), _longToken, bal, _amountOutMin, address(this));

    }

    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor,address _swapImplementation) external virtual {
        openPosition(_shortToken, _shortCToken, _borrowAmount, _borrowFactor);

        uint256 bal = IERC20(_shortToken).balanceOf(address(this));
        uint256 _amountOutMin = swapImplementation(_swapImplementation)._getAmountOutMin(address(dai), _shortToken, bal);
        swapImplementation(_swapImplementation).swap(_shortToken, address(dai), bal, _amountOutMin, address(this));

    }


    /*
░█─░█ █▀▀ █── █▀▀█ █▀▀ █▀▀█ █▀▀ 
░█▀▀█ █▀▀ █── █──█ █▀▀ █▄▄▀ ▀▀█ 
░█─░█ ▀▀▀ ▀▀▀ █▀▀▀ ▀▀▀ ▀─▀▀ ▀▀▀
    */

    function supply(uint _amount) external virtual  {
        token.transferFrom(msg.sender, address(this), _amount);
        token.approve(address(cToken), _amount);
        require(cToken.mint(_amount) == 0, "mint failed");
    }

    function enterMarkets() internal virtual  {
        address[] memory cTokens = new address[](1);
        cTokens[0] = address(cToken);
        uint[] memory errors = comptroller.enterMarkets(cTokens);
        require(errors[0] == 0, "Comptroller.enterMarkets failed.");
    }

    // not view function
    function getInfo() external virtual  returns (uint exchangeRate, uint supplyRate) {
        // Amount of current exchange rate from cToken to underlying
        exchangeRate = cToken.exchangeRateCurrent();
        // Amount added to you supply balance this block
        supplyRate = cToken.supplyRatePerBlock();
    }

    // not view function
    function estimateBalanceOfUnderlying() external virtual  returns (uint) {
        uint cTokenBal = cToken.balanceOf(address(this));
        uint exchangeRate = cToken.exchangeRateCurrent();
        uint decimals = 8; // WBTC = 8 decimals
        uint cTokenDecimals = 8;

        return (cTokenBal * exchangeRate) / 10**(18 + decimals - cTokenDecimals);
    }

    // not view function
    function getSuppliedBalance() external virtual  returns (uint) {
        return cToken.balanceOfUnderlying(address(this));
    }

    function redeem(uint _cTokenAmount) external virtual  {
        require(cToken.redeem(_cTokenAmount) == 0, "redeem failed");
        // cToken.redeemUnderlying(underlying amount);
    }

    // enter market and borrow
    function borrow(address _cTokenToBorrow) external virtual  {
        enterMarkets();

        uint256 liquidity = checkLiquidity(); // USD scaled up by 1e18
        uint256 price = getPriceFeed(_cTokenToBorrow); // USD scaled up by 1e18

        // decimals - decimals of token to borrow
        uint256 maxBorrow = getMaxBorrow(liquidity, price);
        require(maxBorrow > 0, "max borrow = 0");

        // borrow 50% of max borrow
        uint amount = (maxBorrow * 50) / 100;
        require(CErc20(_cTokenToBorrow).borrow(amount) == 0, "borrow failed");
    }

    // borrowed balance (includes interest)
    // not view function
    function getBorrowBalance(address _cTokenBorrowed) public virtual  returns (uint) {
        return CErc20(_cTokenBorrowed).borrowBalanceCurrent(address(this));
    }

    // repay borrow
    function repay(address _tokenBorrowed, address _cTokenBorrowed, uint _amount) external virtual  {
        IERC20(_tokenBorrowed).approve(_cTokenBorrowed, _amount);
        // _amount = 2 ** 256 - 1 means repay all
        require(CErc20(_cTokenBorrowed).repayBorrow(_amount) == 0, "repay failed");
    }


       /*
    ░█──░█ ─▀─ █▀▀ █───█ 　 ░█▀▀▀ █──█ █▀▀▄ █▀▀ ▀▀█▀▀ ─▀─ █▀▀█ █▀▀▄ █▀▀ 
    ─░█░█─ ▀█▀ █▀▀ █▄█▄█ 　 ░█▀▀▀ █──█ █──█ █── ──█── ▀█▀ █──█ █──█ ▀▀█ 
    ──▀▄▀─ ▀▀▀ ▀▀▀ ─▀─▀─ 　 ░█─── ─▀▀▀ ▀──▀ ▀▀▀ ──▀── ▀▀▀ ▀▀▀▀ ▀──▀ ▀▀▀
    */

    function getCTokenBalance() external virtual  view returns (uint) {
        return cToken.balanceOf(address(this));
    }

    // open price feed - USD price of token to borrow
    function getPriceFeed(address _cToken) public virtual  view returns (uint) {
        // scaled up by 1e18
        return priceFeed.getUnderlyingPrice(_cToken);
    }

    function getCollateralFactor() external virtual  view returns (uint) {
        (bool isListed, uint colFactor, bool isComped) = comptroller.markets(address(cToken));
        return colFactor; // divide by 1e18 to get in %
    }

    // borrow rate
    function getBorrowRatePerBlock(address _cTokenBorrowed) external virtual  view returns (uint) {
        // scaled up by 1e18
        return CErc20(_cTokenBorrowed).borrowRatePerBlock();
    }

    function checkLiquidity() public virtual  view returns (uint256){
        (uint256 liquidity, uint256 shortfall) = getAccountLiquidity();

        require(shortfall == 0, "shortfall > 0");
        require(liquidity > 0, "liquidity = 0");
        
        return liquidity;
    }

    // account liquidity - calculate how much can I borrow?
    // sum of (supplied balance of market entered * col factor) - borrowed
    function getAccountLiquidity() public virtual  view returns (uint256 liquidity, uint256 shortfall) {
        // liquidity and shortfall in USD scaled up by 1e18
        (uint256 error, uint256 _liquidity, uint256 _shortfall) = comptroller.getAccountLiquidity(address(this));
        require(error == 0, "error");
        // normal circumstance: liquidity > 0 and shortfall == 0
        // liquidity > 0 means account can borrow up to `liquidity`
        // shortfall > 0 is subject to liquidation, user has borrowed over limit
        return (_liquidity, _shortfall);
    }

    function getMaxBorrow(uint256 liquidity, uint256 price) public virtual  view returns (uint) {
        return (liquidity * (10**cTokenBorrowDecimals)) / price;
    }
}