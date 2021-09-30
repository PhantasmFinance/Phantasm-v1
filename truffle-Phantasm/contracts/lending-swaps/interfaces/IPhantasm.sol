// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IPhantasm {

    function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor) external;
    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor) external;

    function openPosition(address _borrowToken, address _borrowCToken, uint256 initialAmount, uint256 _borrowFactor) external;
    function addCollateral(address _borrowToken, address _borrowCToken, uint256 _collateralAmount, uint256 _borrowFactor) external returns(uint256);
    function closePosition(address _borrowedToken, address _borrowedCToken, address _collateralCToken) external;

    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) external;
    function _getAmountOutMin(address _tokenIn, address _tokenOut, uint _amountIn) external view returns (uint);

    function supply(address _token, address _cToken, uint256 _amount) external;
    function enterMarkets(address _cToken) external;
    function redeem(address _cToken, uint _cTokenAmount) external;
    function borrow(address _cTokenToBorrow, uint256 _cTokenDecimals) external;
    function repay(address _tokenBorrowed, address _cTokenBorrowed, uint256 _amount) external;

    function getInfo(address _cToken) external returns (uint256 exchangeRate, uint256 supplyRate);
    function estimateBalanceOfUnderlying(address _cToken, uint256 _cTokenDecimals, uint256 _tokenDecimals) external returns (uint256);
    function getSuppliedBalance(address _cToken) external returns (uint256);
    function getCollateralFactor(address _cToken) external view returns (uint256);
    function getBorrowBalance(address _cToken) external returns (uint256);
    function getCTokenBalance(address _cToken) external view returns (uint256);
    function getPriceFeed(address _cToken) external view returns (uint256);
    function getBorrowRatePerBlock(address _cTokenBorrowed) external view returns (uint256);

    function checkLiquidity() external view returns (uint256);
    function getAccountLiquidity() external view returns (uint256 liquidity, uint256 shortfall);
    function getMaxBorrow(uint256 liquidity, uint256 price, uint256 _cTokenBorrowDecimals) external view returns (uint256);
}