// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


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
