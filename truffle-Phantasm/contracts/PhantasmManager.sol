// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// Some interfaces are needed here
import "./interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import './interfaces/swapImplementation.sol';


interface lenderImplementation {
    function leverageLong(address _asset, address _swapper, uint256 _initialCollateralAmount, uint256 _initialBorrowAmount, uint256 _borrowFactor) external returns (uint256, uint256);
    function leverageShort(address _asset, address _swapper, uint256 _initialCollateralAmount, uint256 _initialBorrowAmount, uint256 _borrowFactor) external returns (uint256, uint256);
    function closePosition(address _debtAsset, address _asset, address _swapper, uint256 _debtOwed, uint256 _totalCollateral) external;
}

interface bondImplementation {
    function collectAllInterest(address _token) external returns (uint256 _amountCollected);
    function findAndBuyYieldTokens(address _token, uint256 _amount) external returns (uint256 _amountSpent);
    function buyYieldTokens (address _assetPool, uint64 _depositId, uint256 _stableInAmount) external returns (uint64 _fundingID, uint256 fundingMultitokensMinted, uint256 actualFundAmount, uint256 principalFunded);
}
contract PhantasmManager is ERC721 {

    address private owner;

    struct Position {
        bool    isLong;
        bool    isInsulated;
        address asset;
        address stablecoin;
        uint256 debtOwed;
        uint256 totalCollateral;
        uint64  lender;

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
    address[] public bondImplementations;

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

    function addBondImplementation(address _implementation) onlyOwner public {
        bondImplementations.push(_implementation);
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
        uint256 _borrowFactor,
        uint256 _assetAmount,
        uint256 _initialBorrow
) public returns (uint256) {
        //function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        IERC20(_longToken).transferFrom(msg.sender, address(this), _assetAmount);
        IERC20(_longToken).approve(lenderImplementations[_lenderImplementation], _assetAmount);
        (uint256 totalBorrow, uint256 totalCollateral) = lenderImplementation(lenderImplementations[_lenderImplementation]).leverageLong(_longToken, swapImplementations[_swapImplementation], _assetAmount, _initialBorrow, _borrowFactor);
        

        Position memory createdPosition;

        createdPosition.isLong = true;
        createdPosition.isInsulated = false;
        createdPosition.asset = _longToken;
        createdPosition.debtOwed = totalBorrow;
        createdPosition.stablecoin = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI for now
        createdPosition.totalCollateral = totalCollateral;
        createdPosition.lender = _lenderImplementation;


        uint256 PositionID = addPosition(createdPosition);
        return PositionID;
    }

    function closeLongPosition(uint256 _tokenID, uint8 _swapImplementation, uint256 _interestAccured) public {
            require(ownerOf(_tokenID) == msg.sender, "You have to own something to get it's value");
            Position memory liquidateMe = viewPosition(_tokenID);
            //swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to)
            // DAI to repay
            uint256 amountToRepay = _interestAccured + liquidateMe.debtOwed;
            IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).transferFrom(msg.sender, address(this), amountToRepay);
            IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(lenderImplementations[liquidateMe.lender], amountToRepay);
            lenderImplementation(lenderImplementations[liquidateMe.lender]).closePosition(0x6B175474E89094C44Da98b954EedeAC495271d0F, liquidateMe.asset, swapImplementations[_swapImplementation], amountToRepay, liquidateMe.totalCollateral);

    }

    function openShortPositionNFT(
        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _shortToken,
        uint256 _borrowFactor,
        uint256 _assetAmount,
        uint256 _initialBorrow
        ) public returns (uint256) {
            IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).transferFrom(msg.sender, address(this), _assetAmount);
            IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(lenderImplementations[_lenderImplementation], _assetAmount);
            (uint256 totalBorrow, uint256 totalCollateral) = lenderImplementation(lenderImplementations[_lenderImplementation]).leverageShort(_shortToken, swapImplementations[_swapImplementation], _assetAmount, _initialBorrow, _borrowFactor);

            Position memory createdPosition;

            createdPosition.isLong = false;
            createdPosition.isInsulated = false;
            createdPosition.asset = _shortToken;
            createdPosition.debtOwed = totalBorrow;
            createdPosition.stablecoin = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI for now
            createdPosition.totalCollateral = totalCollateral;
            createdPosition.lender = _lenderImplementation;


            uint256 PositionID = addPosition(createdPosition);
            return PositionID;
        }
        function closeShortPosition(uint256 _tokenID, uint8 _swapImplementation, uint256 _interestAccured) public {
            require(ownerOf(_tokenID) == msg.sender, "You have to own something to get it's value");
            Position memory liquidateMe = viewPosition(_tokenID);
            //swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to)
            // DAI to repay
            uint256 amountToRepay = _interestAccured + liquidateMe.debtOwed;
            IERC20(liquidateMe.asset).transferFrom(msg.sender, address(this), amountToRepay);
            IERC20(liquidateMe.asset).approve(lenderImplementations[liquidateMe.lender], amountToRepay);
            lenderImplementation(lenderImplementations[liquidateMe.lender]).closePosition(liquidateMe.asset, 0x6B175474E89094C44Da98b954EedeAC495271d0F, swapImplementations[_swapImplementation], amountToRepay, liquidateMe.totalCollateral);

    }

/*
    _____                 _       _           _ 
    |_   _|               | |     | |         | |
    | |  _ __  ___ _   _| | __ _| |_ ___  __| |
    | | | '_ \/ __| | | | |/ _` | __/ _ \/ _` |
    _| |_| | | \__ \ |_| | | (_| | ||  __/ (_| |
    |_____|_| |_|___/\__,_|_|\__,_|\__\___|\__,_|
                                              
*/
    function openInsulatedLongPositionNFT(
        address _longToken,
        uint256 _borrowFactor,
        uint256 _assetAmount,
        uint256 _initialBorrow,
        uint64 _depositId,
        uint256 stableFundAmount
) public returns (uint256) {
        //function leverageLong(address _longToken, uint256 _borrowAmount, uint256 _borrowFactor, address _swapImplementation) external;
        // Just to see the functions its actually calling because this part is a bit of a mess
        IERC20(_longToken).transferFrom(msg.sender, address(this), _assetAmount);

                // Insure against DAI you will be borrowing
        IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).transferFrom(msg.sender,bondImplementations[0], stableFundAmount);      

        bondImplementation(bondImplementations[0]).buyYieldTokens(0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E, _depositId, stableFundAmount);
        
        IERC20(_longToken).approve(lenderImplementations[0], _assetAmount);

        (uint256 totalBorrow, uint256 totalCollateral) = lenderImplementation(lenderImplementations[0]).leverageLong(_longToken, swapImplementations[0], _assetAmount, _initialBorrow, _borrowFactor);
        


        Position memory createdPosition;

        createdPosition.isLong = true;
        createdPosition.isInsulated = true;
        createdPosition.asset = _longToken;
        createdPosition.debtOwed = totalBorrow;
        createdPosition.stablecoin = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI for now
        createdPosition.totalCollateral = totalCollateral;
        createdPosition.lender = 0;


        uint256 PositionID = addPosition(createdPosition);
        return PositionID;
    }

    function closeInsulatedLongPosition(uint256 _tokenID, uint8 _swapImplementation, uint64 _bondImplementation, uint256 _tipFee) public {
            require(ownerOf(_tokenID) == msg.sender, "You have to own something to get it's value");
            // _tipFee is just incase bond doesn't accure exactly the same and you need to give it a lil boost
            Position memory liquidateMe = viewPosition(_tokenID);
            require(liquidateMe.isInsulated);
            IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).transferFrom(msg.sender, address(this), liquidateMe.debtOwed + _tipFee);
            uint256 amountCollected = bondImplementation(bondImplementations[_bondImplementation]).collectAllInterest(liquidateMe.stablecoin);
            //swap(address _tokenIn, address _tokenOut, uint _amountIn, uint _amountOutMin, address _to)
            // DAI to repay
            uint256 amountToRepay = amountCollected + liquidateMe.debtOwed + _tipFee;
            IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(lenderImplementations[liquidateMe.lender], amountToRepay);
            lenderImplementation(lenderImplementations[liquidateMe.lender]).closePosition(0x6B175474E89094C44Da98b954EedeAC495271d0F, liquidateMe.asset, swapImplementations[_swapImplementation], amountToRepay, liquidateMe.totalCollateral);
    }



}