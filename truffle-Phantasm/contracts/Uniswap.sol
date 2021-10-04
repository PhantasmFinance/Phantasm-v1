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
    IERC20 public WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    
    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to, address[] memory _swapRoute) public returns (uint){
        IERC20(_tokenIn).approve(address(uniswap), _amountIn);

        address[] memory path = _swapRoute;
        

        uniswap.swapExactTokensForTokens(_amountIn, _amountOutMin, path, _to, block.timestamp);

        uint tokensBought = IERC20(_tokenOut).balanceOf(address(this));

        IERC20(_tokenOut).transfer(msg.sender, tokensBought);
    }

}