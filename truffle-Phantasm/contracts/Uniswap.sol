// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import './interfaces/IPhantasm.sol';
import './interfaces/ICompound.sol';
import './interfaces/IUniswap.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Uniswap {
    /*
        █──█ █▀▀▄ ─▀─ █▀▀ █───█ █▀▀█ █▀▀█ 
        █──█ █──█ ▀█▀ ▀▀█ █▄█▄█ █▄▄█ █──█ 
        ─▀▀▀ ▀──▀ ▀▀▀ ▀▀▀ ─▀─▀─ ▀──▀ █▀▀▀
    */
    IUniswapV2Router public uniswap = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IERC20 public USDC = IERC20(0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48);
    
    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) public {
        IERC20(_tokenIn).approve(address(uniswap), _amountIn);

        address[] memory path;
        if (_tokenIn == address(USDC) || _tokenOut == address(USDC)) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = address(USDC);
            path[2] = _tokenOut;
        }

        uniswap.swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);

        IERC20(_tokenOut).transfer(msg.sender, IERC20(_tokenOut).balanceOf(address(this)));
    }

    function _getAmountOutMin(address _tokenIn, address _tokenOut, uint _amountIn) public view returns (uint) {
        address[] memory path;
        if (_tokenIn == address(USDC) || _tokenOut == address(USDC)) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = address(USDC);
            path[2] = _tokenOut;
        }

        // same length as path
        uint[] memory amountOutMins = uniswap.getAmountsOut(_amountIn, path);

        return amountOutMins[path.length - 1];
    }
}
