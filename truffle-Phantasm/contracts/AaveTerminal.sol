// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


import "./interfaces/IERC20.sol";
import "./interfaces/Aave.sol";
import "./interfaces/swapImplementation.sol";

// Updated for Polygon

contract AaveTerminal {
    /*
         .-.
        (o o) boo!
        | O \
        \   \
        `~~~'
    */
    ILendingPool aaveLender = ILendingPool(0x8dFf5E27EA6b7AC08EbFdf9eB090F32ee9a30fcf);

    address public constant DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;

    function depositMoney(uint256 _amount, uint256 _borrowME) public {
        IERC20(DAI).transferFrom(msg.sender, address(this), _amount);
        IERC20(DAI).approve(address(aaveLender), _amount);
        deposit(DAI, _amount);
        aaveLender.setUserUseReserveAsCollateral(DAI, true);
        borrow(DAI,_borrowME);
    }

    function repayDebts(uint256 _amount) public returns (uint256){
        IERC20(DAI).transferFrom(msg.sender, address(this), _amount);
        IERC20(DAI).approve(address(aaveLender), _amount);      
        uint256 amountRepayed = repay(DAI, _amount);
        return amountRepayed;
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