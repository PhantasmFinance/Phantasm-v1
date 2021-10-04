// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./interfaces/DInterest.sol";


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
