// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// Some interfaces are needed here
import "./interfaces/IERC20.sol";
import "./interfaces/DInterest.sol";
import "./interfaces/IPhantasm";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@OpenZeppelin/contracts/token/ERC721/ERC721.sol";

interface swapImplementation {
    function swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to) public virtual override;
}

interface lenderImplementation {
    function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
}

contract PhantasmManager is ERC1155Holder, ERC721 {

    address private owner;

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
        owner = msg.sender
    }

    /*
            __      __         _ _     ______                _   _                 
            \ \    / /        | | |   |  ____|              | | (_)                
            \ \  / /_ _ _   _| | |_  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
            \ \/ / _` | | | | | __| |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
            \  / (_| | |_| | | |_  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
            \/ \__,_|\__,_|_|\__| |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                                                                                
                                                                                
    */
    function addPosition(Position memory _newPosition) internal returns(uint256) {
        counter++;
        //Push Position to ledger
        positionLedger[counter].push(_newPosition);
        
        return counter;
    }
    
    function removePosition(uint256 _tokenID) internal {
        _burn(_tokenID);
    }
    function viewPosition(uint256 _tokenID) public view returns(Position[] memory) {
        return positionLedger[_tokenID];
    }


    /*
      _____                 _                           _        _   _                 
    |_   _|               | |                         | |      | | (_)                
    | |  _ __ ___  _ __ | | ___ _ __ ___   ___ _ __ | |_ __ _| |_ _  ___  _ __  ___ 
    | | | '_ ` _ \| '_ \| |/ _ \ '_ ` _ \ / _ \ '_ \| __/ _` | __| |/ _ \| '_ \/ __|
    _| |_| | | | | | |_) | |  __/ | | | | |  __/ | | | || (_| | |_| | (_) | | | \__ \
    |_____|_| |_| |_| .__/|_|\___|_| |_| |_|\___|_| |_|\__\__,_|\__|_|\___/|_| |_|___/
                    | |                                                               
                    |_|                                                               
    */

    // Needed helper function
    function remove(uint64 index, address[] _array) internal returns(uint[]) {
        if (index >= _array.length) return;

        for (uint i = index; i<_array.length-1; i++){
            _array[i] = _array[i+1];
        }
        delete array[_array.length-1];
        _array.length--;
        return _array;
    }

    address[] public swapImplementations;
    address[] public lenderImplementations;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addSwapImplementation(address _implementation) onlyOwner public {
        swapImplementations.push(_implementation);
    }

    function removeSwapImplementation(uint64 _index) onlyOwner public {
        lenderImplementations = remove(_index, lenderImplementations);

    }

    function addLenderImplementation(address _implementation) onlyOwner public {
        addLenderImplementation.push(_implementation);
    }

    function removeLenderImplementation(uint64 _index) onlyOwner public {
        lenderImplementations = remove(_index, lenderImplementations);
    }

    /*
         _                                    _             
        | |                                  (_)            
        | |     _____   _____ _ __ __ _  __ _ _ _ __   __ _ 
        | |    / _ \ \ / / _ \ '__/ _` |/ _` | | '_ \ / _` |
        | |___|  __/\ V /  __/ | | (_| | (_| | | | | | (_| |
        |______\___| \_/ \___|_|  \__,_|\__, |_|_| |_|\__, |
                                        __/ |         __/ |
                                        |___/         |___/ 
    */

    function openLongPositionNFT(
        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _longToken,
        uint256 _borrowAmount,
        uint256 _borrowFactor
    ) public {
        //function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        lenderImplementation(lenderImplementations[_lenderImplementation]).leverageLong(_longToken, _borrowFactor, _borrowAmount,swapImplementations[_swapImplementation]);
        counter++;
        _mint(msg.sender, counter)
    }

    function openShortPositionNFT(
        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _shortToken,
        address _shortCToken,
        uint256 _borrowAmount,
        uint256 _borrowFactor
    ) public {
        //function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        lenderImplementation(lenderImplementations[_lenderImplementation]).leverageShort(_shortToken, _shortCToken,_borrowAmount, _borrowFactor, swapImplementations[_swapImplementation]);
        counter++;
        _mint(msg.sender, counter)
    }
}