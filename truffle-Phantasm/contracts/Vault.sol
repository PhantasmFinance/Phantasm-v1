// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./interfaces/IERC20.sol";
import "@OpenZeppelin/contracts/token/ERC721/ERC721.sol";

contract Phantasm is ERC721{
    // Define a Struct to represent a position
    struct Position {
        bool    isLong;
        address asset;
        address stablecoin;
        uint256 collateralOwned;
        uint256 amountOwed;
    }
    // Ledger holds all token ids to tokens
    mapping(uint256 => Position[]) private positionLedger;
    uint256 counter = 0;
    constructor() ERC721("Phantasm Position", "SPCTR") {
        
    }

    
    // Define a function to add a position
    function addPosition(Position memory _newPosition) internal returns(uint256) {
        counter++;
        //Push Position to ledger
        positionLedger[counter].push(_newPosition);
        
        return counter;
    }
    
    function removePosition(uint256 _tokenID) public {
        _burn(_tokenID);
    }
    function viewPosition(uint256 _tokenID) public view returns(Position[] memory) {
        return positionLedger[_tokenID];
    }
    function createPosition(bool _isLong, address _asset, address _stablecoin, uint8 _loops) public returns(uint256) {
        // Define known parameters into a new position into memory
        Position memory newPosition;
        newPosition.isLong = _isLong;
        newPosition.asset = _asset;
        newPosition.stablecoin = _stablecoin;
        
        for(uint8 index = _loops; index < _loops; index++) {

        }
        uint256 tokenID = addPosition(newPosition);

        return tokenID;
    }

}