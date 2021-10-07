// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
pragma abicoder v2;

import './interfaces/IUniswap.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

// Thank the Uniswap docs for this last minute migration
contract Uniswap {
    /*
        █──█ █▀▀▄ ─▀─ █▀▀ █───█ █▀▀█ █▀▀█ 
        █──█ █──█ ▀█▀ ▀▀█ █▄█▄█ █▄▄█ █──█ 
        ─▀▀▀ ▀──▀ ▀▀▀ ▀▀▀ ─▀─▀─ ▀──▀ █▀▀▀
    */    

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;    
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    // For this we will set the pool fee to 0.3%.    
    int24 public constant poolFee = 3000;
    
    int24 public constant stablefee = 3000;
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) public returns (uint256 amountOut) {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        
        TransferHelper.safeApprove(_tokenIn, address(swapRouter), _amountIn);
        // Multiple pool swaps are encoded through bytes called a `path`. A path is a sequence of token addresses and poolFees that define the pools used in the swaps.
        // The format for pool encoding is (tokenIn, fee, tokenOut/tokenIn, fee, tokenOut) where tokenIn/tokenOut parameter is the shared token across the pools.
        // Since we are swapping DAI to USDC and then USDC to WETH9 the path encoding is (DAI, 0.3%, USDC, 0.3%, WETH9).
        uint amountOutMin;

        if(_amountOutMin == 0){
            uint amountOutMin = 1;
        } else{
            uint amountOutMin = _amountOutMin;
        }
        ISwapRouter.ExactInputParams memory params =
            ISwapRouter.ExactInputParams({
                path: abi.encodePacked(_tokenIn, stablefee, USDC, poolFee, _tokenOut),
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: _amountIn,
                amountOutMinimum: amountOutMin
            });

        // Executes the swap.
        uint tokensReturned = swapRouter.exactInput(params);
        if(tokensReturned == 0){
            revert("Swap would've burned money");
        }
        uint256 tokensOut = IERC20(_tokenOut).balanceOf(address(this));
        IERC20(_tokenOut).transfer(_to,tokensOut);
        return tokensOut;
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
}
