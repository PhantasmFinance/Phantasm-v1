// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import './interfaces/IPhantasm.sol';
import './interfaces/ICompound.sol';
import './interfaces/IUniswap.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

// Updated for Polygon

contract Uniswap {
    /*
        █──█ █▀▀▄ ─▀─ █▀▀ █───█ █▀▀█ █▀▀█ 
        █──█ █──█ ▀█▀ ▀▀█ █▄█▄█ █▄▄█ █──█ 
        ─▀▀▀ ▀──▀ ▀▀▀ ▀▀▀ ─▀─▀─ ▀──▀ █▀▀▀
    */
    IUniswapV2Router public uniswap = IUniswapV2Router(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506);
    IERC20 public WETH = IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) public returns (uint256) {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);

        IERC20(_tokenIn).approve(address(uniswap), _amountIn);
        address[] memory path;
        path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        uniswap.swapExactTokensForTokens(_amountIn, 1, path, address(this), block.timestamp);
        
        uint256 tokensOut = IERC20(_tokenOut).balanceOf(address(this));
        IERC20(_tokenOut).transfer(_to,tokensOut);
        return tokensOut;
    }

    function _getAmountOutMin(address _tokenIn, address _tokenOut, uint _amountIn) public view returns (uint) {
        address[] memory path;
        if (_tokenIn == address(WETH) || _tokenOut == address(WETH)) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = address(WETH);
            path[2] = _tokenOut;
        }

        // same length as path
        uint[] memory amountOutMins = uniswap.getAmountsOut(_amountIn, path);

        return amountOutMins[path.length - 1];
    }
}
