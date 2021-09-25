// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";


interface DInterest {
    // fund(uint64 depositID, uint256 fundAmount) → uint64 fundingID
    /*
    @param depositID The deposit whose fixed-rate interest will be funded
    @param fundAmount The amount of fixed-rate interest to fund. If it exceeds surplusOfDeposit(depositID), it will be set to the surplus value instead.
    @param fundingID The ID of the fundingMultitoken the sender received
    */
    struct Funding {
        uint64 depositID; // The ID of the associated Deposit struct.
        uint64 lastInterestPayoutTimestamp; // Unix timestamp of the most recent interest payout, in seconds
        uint256 recordedMoneyMarketIncomeIndex; // the income index at the last update (creation or withdrawal)
        uint256 principalPerToken; // The amount of stablecoins that's earning interest for you per funding token you own. Scaled to 18 decimals regardless of stablecoin decimals.
    }
    function fund(uint64, uint256) external returns (uint64);
    // Monitor deposit events to be emitted to scrape depositIDs

    function getFunding(uint64) external returns (Funding memory);
}

interface Phantasm {
    function initiatePosition(uint256 _amount) external;
}

contract EEmph is ERC1155Holder {
    
    event tokensBought(uint256);
    function buyDAITokens(uint64 _fundingID, uint256 _amount) public returns (uint256) {
        // Approve DInterest to spend all DAI
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(0x11B1c87983F881B3686F8b1171628357FAA30038, _amount);
        // The DAI compound pool
        uint64 fundingID = DInterest(0x11B1c87983F881B3686F8b1171628357FAA30038).fund(_fundingID, _amount);

        DInterest.Funding memory boughtTokens = DInterest(0x11B1c87983F881B3686F8b1171628357FAA30038).getFunding(fundingID);

        emit tokensBought(boughtTokens.principalPerToken);
        return boughtTokens.principalPerToken;
    }
}
