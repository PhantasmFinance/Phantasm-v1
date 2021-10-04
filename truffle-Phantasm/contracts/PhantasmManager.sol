// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// Some interfaces are needed here
import "./interfaces/IERC20.sol";
import "./interfaces/DInterest.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import './interfaces/swapImplementation.sol';


interface lenderImplementation {
    function leverageLong(address _longToken,address _cTokenLong,uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external returns (uint256);
    function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
    function closeLongPosition(address _borrowedToken, address _borrowedCtoken, address _collateralCToken, uint256 _debt, uint256 _value, address _recipient) external;
}


contract PhantasmManager is ERC721 {

    address private owner;

    event gotHere(uint256 _line); // here for now


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
        swapImplementations.push(_implementation);
    }

    function addLenderImplementation(address _implementation) onlyOwner public {
        lenderImplementations.push(_implementation);
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
        address _longCtoken,
        uint256 _borrowAmount,
        uint256 _borrowFactor,
        uint256 _assetAmount,
) public returns (uint256) {
        //function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        require(_assetAmount > _borrowAmount, "Collateral must be bigger than borrowAmount");

        require(IERC20(_longToken).transferFrom(msg.sender, lenderImplementations[_lenderImplementation], _assetAmount), "Transfer Failed");
        // await PhantasmManager.openLongPositionNFT(  borrowMe, 50, AssetAmount ,{"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
      
        uint256 coinsBought = lenderImplementation(lenderImplementations[_lenderImplementation]).leverageLong(_longToken,_longCtoken ,_borrowAmount, _borrowFactor,swapImplementations[_swapImplementation]);
        
        Position memory createdPosition;

        createdPosition.isLong = true;
        createdPosition.asset = _longToken;
        createdPosition.debtOwed = _borrowAmount;
        createdPosition.stablecoin = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI for now
        createdPosition.valueRetained = coinsBought;
        createdPosition.lender = _lenderImplementation;


        uint256 PositionID = addPosition(createdPosition);
        return PositionID;
    }

/*
    function openShortPositionNFT(
        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _shortToken,
        address _shortCToken,
        uint256 _borrowAmount,
        uint256 _borrowFactor
    ) public returns (uint256){
        //function leverageShort(address _shortToken, address _shortCToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        lenderImplementation(lenderImplementations[_lenderImplementation]).leverageShort(_shortToken, _shortCToken,_borrowAmount, _borrowFactor, swapImplementations[_swapImplementation]);

        Position memory createdPosition;

        createdPosition.isLong = false;
        createdPosition.asset = _shortToken;
        createdPosition.debtOwed = _borrowAmount;
        createdPosition.stablecoin = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI for now
        createdPosition.lender = _lenderImplementation;


        uint256 PositionID = addPosition(createdPosition);

        return PositionID;
    }
    */
    // fix args for this, but needed them here to start passing tests
    
    function closeLongPosition(uint256 _tokenID, address _borrowedCToken, address _collateralCToken, uint8 _swapImplementation) public {
        require(ownerOf(_tokenID) == msg.sender, "You have to own something to get it's value");
        Position memory liquidateMe = viewPosition(_tokenID);
        //swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to)
        IERC20(liquidateMe.asset).transfer(swapImplementations[_swapImplementation], liquidateMe.valueRetained);
        // swap all of the asset into DAI // MIN_OUt will usually be debt owed
        
        swapImplementation(swapImplementations[_swapImplementation]).swap(liquidateMe.asset, 0x6B175474E89094C44Da98b954EedeAC495271d0F,liquidateMe.valueRetained ,liquidateMe.debtOwed, lenderImplementations[liquidateMe.lender]);
        //function closePosition(address _borrowedToken, address _borrowedCToken, address _collateralCToken, uint256 _debt, uint256 _value, address _recipient)
        // cDAI is only collateral atm

        lenderImplementation(lenderImplementations[liquidateMe.lender]).closeLongPosition(liquidateMe.asset, _borrowedCToken, 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643, liquidateMe.debtOwed, liquidateMe.valueRetained,msg.sender);

    }
    
}
