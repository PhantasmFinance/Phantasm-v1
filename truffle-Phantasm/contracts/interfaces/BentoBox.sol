// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface BentoBox {

    function setMasterContractApproval(address user, address masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) external;

    function deposit(address token_, address from, address to, uint256 amount, uint256 share) external;

    function withdraw(address token_, address from, address to, uint256 amount, uint256 share) external;

}

interface SushiSwapperV1 {
    // swap nonpayable (address,address,address,uint256,uint256)
    function swap(address, address, address, uint256, uint256) external;
}

interface Kashi {
    /*
    Parameters
    address to
    bool skim
    uint256 share
    Allows a user to add collateral from BentoBox or by transferring them to the contract and skimming. The user must have approved the master contract.
    */
    function addCollateral(address, bool, uint256) external;
 
    /*
    Parameters
    address to
    uint256 amount
    Return Values
    uint256 part Total part of the debt held by borrowers.
    uint256 share Total amount in shares borrowed.
    Allows to borrow a given amount if the user stays solvent. Sender borrows amount and transfers it to to.
    */
    function borrow(address, uint256) external returns(uint256, uint256);
}