// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface BentoBox {
    function setMasterContractApproval(
        address user,
        address masterContract,
        bool approved,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function deposit(
        address,
        address,
        address,
        uint256,
        uint256
    ) external;

    function withdraw(
        address,
        address,
        address,
        uint256,
        uint256
    ) external;

    function toAmount(
        address,
        uint256,
        bool
    ) external view returns (uint256);

    function toShare(
        address,
        uint256,
        bool
    ) external view returns (uint256);
}

interface SushiSwapperV1 {
    // swap nonpayable (address,address,address,uint256,uint256)
    function swap(
        address,
        address,
        address,
        uint256,
        uint256
    ) external;
}

interface Kashi {
    /*
    Parameters
    address to
    bool skim
    uint256 share
    Allows a user to add collateral from BentoBox or by transferring them to the contract and skimming. The user must have approved the master contract.
    */
    function addCollateral(
        address,
        bool,
        uint256
    ) external;

    /*
    Parameters
    address to
    uint256 amount
    Return Values
    uint256 part Total part of the debt held by borrowers.
    uint256 share Total amount in shares borrowed.
    Allows to borrow a given amount if the user stays solvent. Sender borrows amount and transfers it to to.
    */
    function borrow(address, uint256) external returns (uint256, uint256);

    /*
    Parameters
        address to Address of the user this payment should go.
        bool skim True if the amount should be skimmed from the deposit balance of msg.sender. False if tokens from msg.sender in bentoBox should be transferred.
        uint256 part The amount to repay. See userBorrowPart.
        Return Values 
        uint256 amount The total amount repayed.
    */
    function repay(address, bool, uint256) external returns (uint256);

    /*
        removeCollateral nonpayable (address,uint256)

        Parameters

        address to

        uint256 share
    */
    function removeCollateral(address, uint256) external;
}
