// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@OpenZeppelin/contracts/token/ERC721/ERC721.sol";

contract test1 is ERC721 {
    constructor() ERC721("PhantasmPosition", "SPCTR") {

    }


    function createPosition() public {

    }

    function destroyPosition() public {
        
    }
}