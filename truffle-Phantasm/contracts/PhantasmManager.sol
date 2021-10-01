// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// Some interfaces are needed here
import "./interfaces/IERC20.sol";
import "./interfaces/DInterest.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import './interfaces/swapImplementation.sol';


interface lenderImplementation {
    function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
}

contract PhantasmManager is ERC721 {

    address private owner;

    struct Position {
        bool    isLong;
        address asset;
        address stablecoin;
        uint256 debtOwed;
        uint256 valueRetained;
        uint64 lender;

    }
    // Ledger holds all token ids to tokens
    mapping(uint256 => Position) private positionLedger;
    uint256 counter = 0;
    constructor() ERC721("Phantasm Position", "SPCTR") {
        owner = msg.sender;
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
        positionLedger[counter] = _newPosition;

        _mint(msg.sender, counter);
        
        return counter;
    }
    
    function removePosition(uint256 _tokenID) internal {
        _burn(_tokenID);

        delete positionLedger[_tokenID];
    }
    function viewPosition(uint256 _tokenID) public view returns(Position memory) {
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


    address[] public swapImplementations;
    address[] public lenderImplementations;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addSwapImplementation(address _implementation) onlyOwner public {
        swapImplementations[swapImplementations.length] = _implementation;
    }

    function addLenderImplementation(address _implementation) onlyOwner public {
        lenderImplementations[lenderImplementations.length] = _implementation;
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
        uint256 _borrowFactor,
        uint256 _assetAmount
    ) public {
        //function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        require(IERC20(_longToken).transferFrom(msg.sender,lenderImplementations[_lenderImplementation],_assetAmount));
        require(_assetAmount > _borrowAmount);

        lenderImplementation(lenderImplementations[_lenderImplementation]).leverageLong(_longToken, _borrowFactor, _borrowAmount,swapImplementations[_swapImplementation]);
        
        Position memory createdPosition;

        createdPosition.isLong = true;
        createdPosition.asset = _longToken;
        createdPosition.debtOwed = _borrowAmount;
        createdPosition.stablecoin = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI for now
        createdPosition.valueRetained = _assetAmount - _borrowAmount;
        createdPosition.lender = _lenderImplementation;


        addPosition(createdPosition);
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

        Position memory createdPosition;


        addPosition(createdPosition);
    }

    // fix args for this, but needed them here to start passing tests
    /*
    function closeLongPosition(uint256 _tokenID, address _borrowedCToken, address _collateralCToken) public {
        /*
        Not even close to being done
        require(ownerOf(_tokenID) == msg.sender);

        // Next fetch the position

        Position storage liquidateMe = positionLedger[_tokenID];
        require(liquidateMe.isLong);
        //closePosition(address _borrowedToken, address _borrowedCToken, address _collateralCToken, uint256 _debt, uint256 _value, address _recipient)

        //lenderImplementation(lenderImplementations[liquidateMe.lender]).closePosition(liquidateMe.asset, , , liquidateMe.debtOwed, liquidateMe.valueRetained, msg.sender)
    }
    */
}
