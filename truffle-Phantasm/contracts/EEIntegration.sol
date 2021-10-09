// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// Updated for Polygon

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './interfaces/IDInterest.sol';
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
contract EEIntegration is ERC1155Holder {

    IERC20 public dai = IERC20(0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063);
    DInterest public daiViaAavePool = DInterest(0x18a68F81E2E4f2A23604e9b067bf3fa1118B1990);
    address PhantasmManager;

    mapping (address => mapping (address => uint64[])) public myFundingIDs; // Pool Address => User Address => Funding Id

    constructor(address _phantasmManager) {
        PhantasmManager = _phantasmManager; 
    }
    function findAndBuyYieldTokens(address _token, uint256 _amount) public returns (uint256 _amountSpent) {
        uint256 amountLeft = _amount;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](1);
            daiPools[0] = daiViaAavePool;

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
            daiPools = new DInterest[](1);
            daiPools[0] = daiViaAavePool;
            
            for (uint256 i = 0; i < daiPools.length; i++) {
                if (myFundingIDs[address(daiPools[i])][msg.sender].length != 0) {
                    for (uint64 j = 0; j < myFundingIDs[address(daiPools[i])][msg.sender].length; j++) {
                        amountCollected = amountCollected + collectInterest(address(daiPools[i]), myFundingIDs[address(daiPools[i])][msg.sender][j]);
                    }
                }
            }
        }
        // Works because _token is DAI, but IIRC interest is accured in the actual asset, not DAI
        IERC20(_token).transfer(PhantasmManager, amountCollected);
        return amountCollected;
    }

    // Returns The Total Amount the User is Insured for (or earning yield on)
    function getUserInsuredAmount (address _token) public view returns (uint256 _totalAmountInsured) {
        uint256 insuredAmount = 0;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](1);
            daiPools[0] = daiViaAavePool;

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

    // NEEDS TO BE REVISED => thisYTPrice should be the *Price* to buy the yield tokens => not the total amount of Yield Tokens
    function getTotalYTInBudget (address _token, uint256 _amountIn) public view returns (uint256 _insuranceAvailable) {
        uint256 insuranceAvailable = 0;
        uint256 amountLeft = _amountIn;
        if (_token == address(dai)) {
            DInterest[] memory daiPools;
            daiPools = new DInterest[](1);
            daiPools[0] = daiViaAavePool;

            for (uint256 i = 0; i < daiPools.length; i++) {
                if (daiPools[i].depositsLength() != 0) {
                    for (uint64 j = 1; j <= daiPools[i].depositsLength(); j++) {
                        uint256 thisYTPrice = getYTPriceFromDeposit(address(daiPools[i]), j);
                        if (amountLeft > thisYTPrice && daiPools[i].getDeposit(j).fundingID == 0) {
                            amountLeft = amountLeft - thisYTPrice;
                            insuranceAvailable = insuranceAvailable + thisYTPrice;
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

    function getYTPriceFromDeposit(address _assetPool, uint64 _depositID) public view returns (uint256) {
        return (DInterest(_assetPool).getDeposit(_depositID).interestRate / DInterest(_assetPool).getDeposit(_depositID).maturationTimestamp - block.timestamp) * DInterest(_assetPool).getDeposit(_depositID).virtualTokenTotalSupply;
    }
}
