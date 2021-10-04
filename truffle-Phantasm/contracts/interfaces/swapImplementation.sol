// SPDX-License-Identifier: MIT
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
interface swapImplementation {
    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) external returns (uint);

    function _getAmountOutMin(address _tokenIn, address _tokenOut, uint _amountIn) external view returns (uint);
}
