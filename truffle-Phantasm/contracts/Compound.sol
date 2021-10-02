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


    constructor () {

    }

    receive() external payable {}

    /*
    ░█▀▀█ █▀▀█ ─▀─ █▀▄▀█ █▀▀█ █▀▀█ █──█ 　 ░█▀▀▀ █──█ █▀▀▄ █▀▀ ▀▀█▀▀ ─▀─ █▀▀█ █▀▀▄ █▀▀ 
    ░█▄▄█ █▄▄▀ ▀█▀ █─▀─█ █▄▄█ █▄▄▀ █▄▄█ 　 ░█▀▀▀ █──█ █──█ █── ──█── ▀█▀ █──█ █──█ ▀▀█ 
    ░█─── ▀─▀▀ ▀▀▀ ▀───▀ ▀──▀ ▀─▀▀ ▄▄▄█ 　 ░█─── ─▀▀▀ ▀──▀ ▀▀▀ ──▀── ▀▀▀ ▀▀▀▀ ▀──▀ ▀▀▀
    */


    function openPosition(address _borrowToken, address _borrowCToken, uint256 initialAmount, uint256 _borrowFactor) internal  {
        uint256 nextCollateralAmount = initialAmount;
        enterMarkets(_borrowCToken);
        //for(uint i = 0; i < 5; i++) {
        nextCollateralAmount = addCollateral(_borrowToken, _borrowCToken, nextCollateralAmount, _borrowFactor);
        //}
    }

    function addCollateral(address _borrowToken, address _borrowCToken, uint256 _collateralAmount, uint256 _borrowFactor) internal returns(uint256) {
        IERC20(_borrowToken).approve(_borrowCToken, _collateralAmount);
        require(CErc20(_borrowCToken).mint(_collateralAmount) == 0, "mint failed");
        uint borrowAmount = (_collateralAmount * _borrowFactor) / 100;
        // Borrow

        require(CErc20(_borrowCToken).borrow(10000) == 0, "Borrow Failed");
        return borrowAmount;
    }

    function closePosition(address _borrowedToken, address _borrowedCToken, address _collateralCToken, uint256 _debt, uint256 _value, address _recipient) external   {
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

    function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external  {
        openPosition(address(dai), address(cDai), _borrowAmount, _borrowFactor);

        uint256 bal = dai.balanceOf(address(this));
        uint256 _amountOutMin = swapImplementation(_swapImplementation)._getAmountOutMin(address(dai), _longToken, bal);
        IERC20(dai).transfer(_swapImplementation, bal);
        swapImplementation(_swapImplementation).swap(address(dai), _longToken, bal, _amountOutMin, address(this));

    }

    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor,address _swapImplementation) external  {
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

    function supply(address _token, address _cToken, uint _amount) external   {
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        IERC20(_token).approve(_cToken, _amount);
        require(CErc20(_cToken).mint(_amount) == 0, "mint failed");
    }

    // Allow your supplied assets to be lent out and accrue interest
    // _cToken should be the cTokens the contract has supplied
    function enterMarkets(address _cToken) public   {
        address[] memory cTokens = new address[](1);
        cTokens[0] = _cToken;
        uint[] memory errors = comptroller.enterMarkets(cTokens);
        require(errors[0] == 0, "Comptroller.enterMarkets failed.");
    }

    // not view function
    function getInfo(address _cToken) external   returns (uint exchangeRate, uint supplyRate) {
        // Amount of current exchange rate from cToken to underlying
        exchangeRate = CErc20(_cToken).exchangeRateCurrent();
        // Amount added to you supply balance this block
        supplyRate = CErc20(_cToken).supplyRatePerBlock();
    }

    // not view function
    // Do Something about the decimals
    function estimateBalanceOfUnderlying(address _cToken, uint256 _cTokenDecimals, uint256 _tokenDecimals) external   returns (uint) {
        uint cTokenBal = CErc20(_cToken).balanceOf(address(this));
        uint exchangeRate = CErc20(_cToken).exchangeRateCurrent();

        return (cTokenBal * exchangeRate) / 10**(18 + _tokenDecimals - _cTokenDecimals);
    }

    // not view function
    function getSuppliedBalance(address _cToken) external   returns (uint) {
        return CErc20(_cToken).balanceOfUnderlying(address(this));
    }

    function redeem(address _cToken, uint _cTokenAmount) external   {
        require(CErc20(_cToken).redeem(_cTokenAmount) == 0, "redeem failed");
        // cToken.redeemUnderlying(underlying amount);
    }

    // enter market and borrow
    function externalBorrow(address _cTokenToBorrow, uint256 _cTokenDecimals) external   {

        uint256 liquidity = checkLiquidity(); // USD scaled up by 1e18
        uint256 price = getPriceFeed(_cTokenToBorrow); // USD scaled up by 1e18

        // decimals - decimals of token to borrow
        uint256 maxBorrow = getMaxBorrow(liquidity, price, _cTokenDecimals);
        require(maxBorrow > 0, "max borrow = 0");

        // borrow 50% of max borrow
        uint amount = (maxBorrow * 50) / 100;
        require(CErc20(_cTokenToBorrow).borrow(amount) == 0, "borrow failed");
    }

    // borrowed balance (includes interest)
    // not view function
    function getBorrowBalance(address _cToken) public   returns (uint) {
        return CErc20(_cToken).borrowBalanceCurrent(address(this));
    }

    // repay borrow
    function repay(address _tokenBorrowed, address _cTokenBorrowed, uint256 _amount) external   {
        IERC20(_tokenBorrowed).approve(_cTokenBorrowed, _amount);
        // _amount = 2 ** 256 - 1 means repay all
        require(CErc20(_cTokenBorrowed).repayBorrow(_amount) == 0, "repay failed");
    }


       /*
    ░█──░█ ─▀─ █▀▀ █───█ 　 ░█▀▀▀ █──█ █▀▀▄ █▀▀ ▀▀█▀▀ ─▀─ █▀▀█ █▀▀▄ █▀▀ 
    ─░█░█─ ▀█▀ █▀▀ █▄█▄█ 　 ░█▀▀▀ █──█ █──█ █── ──█── ▀█▀ █──█ █──█ ▀▀█ 
    ──▀▄▀─ ▀▀▀ ▀▀▀ ─▀─▀─ 　 ░█─── ─▀▀▀ ▀──▀ ▀▀▀ ──▀── ▀▀▀ ▀▀▀▀ ▀──▀ ▀▀▀
    */

    function getCTokenBalance(address _cToken) external   view returns (uint) {
        return CErc20(_cToken).balanceOf(address(this));
    }

    // open price feed - USD price of token to borrow
    function getPriceFeed(address _cToken) public   view returns (uint) {
        // scaled up by 1e18
        return priceFeed.getUnderlyingPrice(_cToken);
    }

    function getCollateralFactor(address _cToken) external   view returns (uint) {
        (bool isListed, uint colFactor, bool isComped) = comptroller.markets(_cToken);
        return colFactor; // divide by 1e18 to get in %
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // borrow rate
    function getBorrowRatePerBlock(address _cTokenBorrowed) external   view returns (uint) {
        // scaled up by 1e18
        return CErc20(_cTokenBorrowed).borrowRatePerBlock();
    }

    function checkLiquidity() public   view returns (uint256){
        (uint256 liquidity, uint256 shortfall) = getAccountLiquidity();

        require(shortfall == 0, "shortfall > 0");
        require(liquidity > 0, "liquidity = 0");
        
        return liquidity;
    }

    // account liquidity - calculate how much can I borrow?
    // sum of (supplied balance of market entered * col factor) - borrowed
    function getAccountLiquidity() public  view returns (uint256 liquidity, uint256 shortfall) {
        // liquidity and shortfall in USD scaled up by 1e18
        (uint256 error, uint256 _liquidity, uint256 _shortfall) = comptroller.getAccountLiquidity(address(this));
        require(error == 0, "error");
        // normal circumstance: liquidity > 0 and shortfall == 0
        // liquidity > 0 means account can borrow up to `liquidity`
        // shortfall > 0 is subject to liquidation, user has borrowed over limit
        return (_liquidity, _shortfall);
    }

    function getMaxBorrow(uint256 liquidity, uint256 price, uint256 _cTokenBorrowDecimals) public pure returns (uint) {
        return (liquidity * (10**_cTokenBorrowDecimals)) / price;
    }
}
