// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


import "./interfaces/IERC20.sol";
import "./interfaces/Aave.sol";
import "./interfaces/swapImplementation.sol";

// Updated for Polygon

contract AaveImplementation {
    /*
         .-.
        (o o) boo!
        | O \
        \   \
        `~~~'
    */
    ILendingPool aaveLender = ILendingPool(0x8dFf5E27EA6b7AC08EbFdf9eB090F32ee9a30fcf);

    address public constant DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

    function leverageLong(address _asset, address _swapper, uint256 _initialCollateralAmount, uint256 _initialBorrowAmount, uint256 _borrowFactor) external returns (uint256, uint256) {
        
        IERC20(_asset).transferFrom(msg.sender, address(this), _initialCollateralAmount);
        IERC20(_asset).approve(address(aaveLender), _initialCollateralAmount);
        deposit(_asset, _initialCollateralAmount);

        aaveLender.setUserUseReserveAsCollateral(_asset, true);
        uint256 nextBorrow = _initialCollateralAmount;
        uint256 totalBorrow;
        uint256 totalCollateral = _initialCollateralAmount;
        // After 3 loops law of diminishing returns really kills you
        for(uint i = 0; i < 3; i++){
            uint borrowAmount = (nextBorrow * _borrowFactor) / 100;
            borrow(DAI, borrowAmount);

            totalBorrow += borrowAmount;
            // (address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to
            IERC20(DAI).approve(_swapper, borrowAmount);
            uint256 tokensBought = swapImplementation(_swapper).swap(DAI, _asset,borrowAmount, 1, address(this));

            uint256 nextBorrow = tokensBought;
            // Re-approving each deposit sucks, but is signficiantly safer
            IERC20(_asset).approve(address(aaveLender), tokensBought);
            deposit(_asset, tokensBought);
            totalCollateral += tokensBought;
        }
        return (totalBorrow, totalCollateral);
        
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
    function leverageShort(address _asset, address _swapper, uint256 _initialCollateralAmount, uint256 _initialBorrowAmount, uint256 _borrowFactor) external returns (uint256, uint256) {
        IERC20(DAI).transferFrom(msg.sender, address(this), _initialCollateralAmount);
        IERC20(DAI).approve(address(aaveLender), _initialCollateralAmount);
        deposit(DAI, _initialCollateralAmount);
        aaveLender.setUserUseReserveAsCollateral(DAI, true);
        uint256 nextBorrow = _initialBorrowAmount;
        uint256 totalBorrow;
        uint256 totalCollateral = _initialCollateralAmount;
        // Highly leveraged shorts breaks a lot of things, so I've limited it for now
        uint borrowAmount = (nextBorrow * _borrowFactor) / 100;
        borrow(_asset, borrowAmount);
        totalBorrow += borrowAmount;
        // (address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to
        IERC20(_asset).approve(_swapper, borrowAmount);
        uint256 tokensBought = swapImplementation(_swapper).swap(_asset,DAI,borrowAmount, 1, address(this));
        IERC20(DAI).approve(address(aaveLender), tokensBought);
        deposit(DAI, tokensBought);
        totalCollateral += tokensBought;
    
        return (totalBorrow, totalCollateral);
        
    }
    
    function closePosition(address _debtAsset, address _asset, address _swapper, uint256 _debtOwed, uint256 _totalCollateral) public {
        IERC20(_debtAsset).transferFrom(msg.sender, address(this), _debtOwed);
        IERC20(_debtAsset).approve(address(aaveLender), _debtOwed);
        repay(_debtAsset, _debtOwed);
        // Now with no debt, withdraw collateral
        uint256 amountWithdrawn = withdraw(_asset, _totalCollateral);
        IERC20(_asset).transfer(msg.sender, _totalCollateral);
    }

    /*
        Internal Wrapper functions for dealing with Aave directly
    */
    function deposit(
        address _asset, 
        uint256 _amount
    ) internal {
        //aaveLender.setUserUseReserveAsCollateral(_asset, true);
        aaveLender.deposit(_asset, _amount, address(this), 0);
    }

    function withdraw(
        address _asset,
        uint256 _amount
    ) internal returns (uint256){
        uint256 amountReturned = aaveLender.withdraw(_asset, _amount, address(this));
    }

    function borrow(
        address _asset,
        uint256 _amount
    ) internal {
        aaveLender.borrow(_asset, _amount, 2, 0, address(this));
    }

    function repay(
        address _asset,
        uint256 _amount
    ) internal returns (uint256){
        uint256 amountRepayed = aaveLender.repay(_asset, _amount, 2, address(this));
        return amountRepayed;
    }
}
