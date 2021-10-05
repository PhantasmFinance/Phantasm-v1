// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import './interfaces/IPhantasm.sol';
import './interfaces/ICompound.sol';
import './interfaces/IUniswap.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './interfaces/DInterest.sol';

contract EEIntegration {

    IERC20 public WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 public dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    CErc20 public cDai = CErc20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    DInterest public daiViaAavePool = DInterest(0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E);
    DInterest public daiViaCompoundPool = DInterest(0x11B1c87983F881B3686F8b1171628357FAA30038);

    mapping (address => mapping (address => uint64[])) public myFundingIDs; // Pool Address => User Address => Funding Id

    function findAndBuyYieldTokens(address _token, uint256 _amount) public returns (uint256 _amountSpent) {
        uint256 amountLeft = _amount;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](2);
            daiPools[0] = daiViaAavePool;
            daiPools[1] = daiViaCompoundPool;

            for (uint256 i = 0; i < daiPools.length; i++) {
                if (daiPools[i].depositsLength() != 0) {
                    for (uint64 j = 1; j <= daiPools[i].depositsLength(); j++) {
                        if (daiPools[i].getDeposit(j).fundingID == 0 && amountLeft > 0) {
                            (uint64 fundingID, uint256 fundingMultitokensMinted, uint256 actualFundAmount, uint256 principalFunded) = buyYieldTokens(address(daiPools[i]), j, amountLeft);
                            amountLeft = amountLeft - actualFundAmount;
                            myFundingIDs[address(daiPools[i])][msg.sender].push(fundingID);
                        }
                    }
                }
            }
        }
        require(amountLeft >= 0, "Spent more than taken in");
        return _amount - amountLeft;
    }

    function collectAllInterest(address _token) public returns (uint256 _amountCollected) {
        uint256 amountCollected = 0;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](2);
            daiPools[0] = daiViaAavePool;
            daiPools[1] = daiViaCompoundPool;
            
            for (uint256 i = 0; i < daiPools.length; i++) {
                if (myFundingIDs[address(daiPools[i])][msg.sender].length != 0) {
                    for (uint64 j = 0; j < myFundingIDs[address(daiPools[i])][msg.sender].length; j++) {
                        amountCollected = amountCollected + collectInterest(address(daiPools[i]), myFundingIDs[address(daiPools[i])][msg.sender][j]);
                    }
                }
            }
        }
        return amountCollected;
    }

    // Returns The Total Amount the User is Insured for (or earning yield on)
    function getUserInsuredAmount (address _token) public view returns (uint256 _totalAmountInsured) {
        uint256 insuredAmount = 0;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](2);
            daiPools[0] = daiViaAavePool;
            daiPools[1] = daiViaCompoundPool;

            for (uint256 i = 0; i < daiPools.length; i++) {
                if (myFundingIDs[address(daiPools[i])][msg.sender].length != 0) {
                    for (uint64 j = 0; j < myFundingIDs[address(daiPools[i])][msg.sender].length; j++) {
                        insuredAmount = insuredAmount + getInsuredAmount(address(daiPools[i]), myFundingIDs[address(daiPools[i])][msg.sender][j]);
                    }
                }
            }
        }
        return insuredAmount;
    }

    // NEEDS TO BE REVISED => thisYTAmount should be the *Price* to buy the yield tokens => not the total amount of Yield Tokens
    function getTotalYTInBudget (address _token, uint256 _amountIn) public view returns (uint256 _insuranceAvailable) {
        uint256 insuranceAvailable = 0;
        uint256 amountLeft = _amountIn;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](2);
            daiPools[0] = daiViaAavePool;
            daiPools[1] = daiViaCompoundPool;

            for (uint256 i = 0; i < daiPools.length; i++) {
                if (daiPools[i].depositsLength() != 0) {
                    for (uint64 j = 1; j <= daiPools[i].depositsLength(); j++) {
                        uint256 thisYTAmount = getYTAvailableFromDeposit(address(daiPools[i]), j);
                        if (amountLeft > thisYTAmount && daiPools[i].getDeposit(j).fundingID == 0) {
                            amountLeft = amountLeft - thisYTAmount; // THIS IS WRONG -> thisYTAmount needs to be replaced with the PRICE of thisYTAmount
                            insuranceAvailable = insuranceAvailable + thisYTAmount; // SAME GOES FOR THIS
                        }
                    }
                }
            }
        }
        return insuranceAvailable;
    }

    /*


░█─░█ █▀▀ █── █▀▀█ █▀▀ █▀▀█ █▀▀ 
░█▀▀█ █▀▀ █── █──█ █▀▀ █▄▄▀ ▀▀█ 
░█─░█ ▀▀▀ ▀▀▀ █▀▀▀ ▀▀▀ ▀─▀▀ ▀▀▀

    */

    function buyYieldTokens (address _assetPool, uint64 _depositId, uint256 _stableInAmount) public returns (uint64 _fundingID, uint256 fundingMultitokensMinted, uint256 actualFundAmount, uint256 principalFunded) {
        dai.approve(_assetPool, _stableInAmount);
        return DInterest(_assetPool).fund(_depositId, _stableInAmount);
    }

    // Collect Interest for a given fundingID
    function collectInterest(address _assetPool, uint64 _fundingID) public returns (uint256){
        uint256 interestCollected = DInterest(_assetPool).payInterestToFunders(_fundingID);
        return interestCollected;
    }

    // Amount of stablecoins that's earning interest for you per funding token you own. Scaled to 18 decimals regardless of stablecoin decimals.
    function getInsuredAmount (address _assetPool, uint64 _fundingID) public view returns (uint256) {
        return DInterest(_assetPool).getFunding(_fundingID).principalPerToken;
    }

    function getYTAvailableFromDeposit(address _assetPool, uint64 _depositID) public view returns (uint256) {
        return DInterest(_assetPool).getDeposit(_depositID).virtualTokenTotalSupply;
    }   
}