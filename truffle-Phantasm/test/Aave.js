const BN = require("bn.js");
const { time } = require("@openzeppelin/test-helpers")
const { sendEther } = require("./util");
const { DAI, WBTC_WHALE, sUSD } = require("./config");
const BigNumber = require('bignumber.js');
const { web3 } = require("@openzeppelin/test-helpers/src/setup");
const IERC20 = artifacts.require("IERC20");
const Uniswapper = artifacts.require("Uniswap"); 
const EEmph = artifacts.require("EEIntegration");
const AaveLender = artifacts.require("AaveImplementation");
const Phantasm = artifacts.require("PhantasmManager");

contract("AaveLender", (accounts) => {
    beforeEach(async () => {
      // Setup Chain env
      
      UniswapImplementation = await Uniswapper.new();

      aaveLendingPool = await AaveLender.new();

      PhantasmManager = await Phantasm.new({"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});

      BondImplementation = await EEmph.new(PhantasmManager.address)


      ercWETH = await IERC20.at("0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619"); //Polygon Correct

      erc20DAI = await IERC20.at("0x8f3cf7ad23cd3cadbd9735aff958023239c6a063") //Polygon Correct 
      
      UniswapImplementation = await Uniswapper.new();

      await PhantasmManager.addSwapImplementation(UniswapImplementation.address, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});

      await PhantasmManager.addLenderImplementation(aaveLendingPool.address, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});

      await PhantasmManager.addBondImplementation(BondImplementation.address, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

    });
  
    it("Create a Long Position", async () => {
      // Iterative Tests here


      let AssetAmount = new BigNumber("11000000000000000")

      let initialBorrow = new BigNumber("50000000000000")

      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      let newInterest = new BigNumber("50000000000000000000")

      ercWETH.approve(PhantasmManager.address, maxApproval, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});

      await PhantasmManager.openLongPositionNFT(0,0, "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619", 50, AssetAmount, initialBorrow, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});
      
      console.log("position opened")

      erc20DAI.approve(PhantasmManager.address,maxApproval,{"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"} )

      await PhantasmManager.closeLongPosition(1, 0,newInterest , {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

 
    });
 
    it("Create a Short Position", async () => {
      /*
        Create and close a Short Position through Phantasm Manager
      */


      let AssetAmount = new BigNumber("11000000000000000")

      let initialBorrow = new BigNumber("500000000000")

      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      let newInterest = new BigNumber("50000000000000000000")

      ercWETH.approve(PhantasmManager.address, maxApproval, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

      erc20DAI.approve(PhantasmManager.address, AssetAmount, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});
      /*
        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _shortToken,
        uint256 _borrowFactor,
        uint256 _assetAmount,
        uint256 _initialBorrow
      */
      await PhantasmManager.openShortPositionNFT(0, 0, "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619", 50 ,AssetAmount, initialBorrow, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});
      
      console.log("Short Position created")

      ercWETH.approve(PhantasmManager.address ,maxApproval, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

      await PhantasmManager.closeShortPosition(1, 0,newInterest ,{"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

 
    });
    it("Should Create and Close an Insulated Position", async () => {

      let AssetAmount = new BigNumber("11000000000000000")

      let initialBorrow = new BigNumber("50000000000000")

      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      let newInterest = new BigNumber("50000000000000000000")

      let AssetinDai = new BigNumber("3910000000000000000")


      ercWETH.approve(aaveLendingPool.address, AssetAmount, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

      erc20DAI.approve(PhantasmManager.address, maxApproval, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})
      /*
    function openInsulatedLongPositionNFT(
        address _longToken,
        uint256 _borrowFactor,
        uint256 _assetAmount,
        uint256 _initialBorrow,
        address _88mphPool,
        uint64 _depositId,
        uint256 stableFundAmount
      */
      await PhantasmManager.openInsulatedLongPositionNFT("0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619", 50, AssetAmount, initialBorrow,"0x18a68F81E2E4f2A23604e9b067bf3fa1118B1990", 1, AssetinDai, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});
      
      console.log("position opened")

      const block = await web3.eth.getBlockNumber()
      await time.advanceBlockTo(block + 100)
      //     function closeInsulatedLongPosition(uint256 _tokenID, uint8 _swapImplementation, uint64 _bondImplementation) public {

      await PhantasmManager.closeInsulatedLongPosition(1,0,0, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

    })
  });
