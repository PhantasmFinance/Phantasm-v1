// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IPhantasm {

    function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor,address _swapImplementation) external;
    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor,address _swapImplementation) external;

    function openPosition(address _borrowToken, address _borrowCToken, uint256 initialAmount, uint256 _borrowFactor) external;
    function addCollateral(address _borrowToken, address _borrowCToken, uint256 _collateralAmount, uint256 _borrowFactor) external returns(uint256);
    function closePosition(address _borrowedToken, address _borrowedCToken, address _collateralCToken) external;

    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) external;
    function _getAmountOutMin(address _tokenIn, address _tokenOut, uint _amountIn) external view returns (uint);

    function supply(uint256 _amount) external;
    function enterMarkets() external;
    function redeem(uint256 _cTokenAmount) external;
    function borrow(address _cTokenToBorrow) external;
    function repay(address _tokenBorrowed, address _cTokenBorrowed, uint256 _amount) external;

    function getInfo() external returns (uint256 exchangeRate, uint256 supplyRate);
    function estimateBalanceOfUnderlying() external returns (uint256);
    function getSuppliedBalance() external returns (uint256);
    function getCollateralFactor() external view returns (uint256);
    function getBorrowBalance(address _cTokenBorrowed) external returns (uint256);
    function getCTokenBalance() external view returns (uint256);
    function getPriceFeed(address _cToken) external view returns (uint256);
    function getBorrowRatePerBlock(address _cTokenBorrowed) external view returns (uint256);

    function checkLiquidity() external view returns (uint256);
    function getAccountLiquidity() external view returns (uint256 liquidity, uint256 shortfall);
    function getMaxBorrow(uint256 liquidity, uint256 price) external view returns (uint256);
}