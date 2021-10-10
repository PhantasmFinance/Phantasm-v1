const BN = require("bn.js");
const { time } = require("@openzeppelin/test-helpers")
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");
const BigNumber = require('bignumber.js');
const IERC20 = artifacts.require("IERC20");
const Uniswapper = artifacts.require("Uniswap"); 
const EEmph = artifacts.require("EEIntegration");
const AaveLender = artifacts.require("AaveImplementation");
const Phantasm = artifacts.require("PhantasmManager");

contract("AaveLender", (accounts) => {
    beforeEach(async () => {
      // Setup Chain env

      LINK = await IERC20.at("0x514910771af9ca656af840dff83e8264ecf986ca");

      erc20DAI = await IERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F") 
      

      UniswapImplementation = await Uniswapper.new();

      aaveLendingPool = await AaveLender.new();

      PhantasmManager = await Phantasm.new({"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      BondImplementation = await EEmph.new(PhantasmManager.address)


      LINK = await IERC20.at("0x514910771af9ca656af840dff83e8264ecf986ca");

      erc20DAI = await IERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F") 
      
      UniswapImplementation = await Uniswapper.new();

      await PhantasmManager.addSwapImplementation(UniswapImplementation.address, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      await PhantasmManager.addLenderImplementation(aaveLendingPool.address, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      await PhantasmManager.addBondImplementation(BondImplementation.address, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})

    });
  
    it("Create a Long Position", async () => {
      // Iterative Tests here


      let AssetAmount = new BigNumber("11000000000000000")

      let initialBorrow = new BigNumber("50000000000")


      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      let newInterest = new BigNumber("500000000000")

      LINK.approve(PhantasmManager.address, maxApproval, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      await PhantasmManager.openLongPositionNFT(0,0, "0x514910771af9ca656af840dff83e8264ecf986ca", 50, AssetAmount, initialBorrow, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});
      
      console.log("position opened")

      erc20DAI.approve(PhantasmManager.address,maxApproval,{"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"} )

      await PhantasmManager.closeLongPosition(1, 0,newInterest , {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})

 
    });


    it("Create a Short Position", async () => {
      // Iterative Tests here


      let AssetAmount = new BigNumber("11000000000000")

      LINK.approve(aaveLendingPool.address, AssetAmount, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})

      let borrowMe = new BigNumber("500000000000")

      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      erc20DAI.approve(aaveLendingPool.address, AssetAmount, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      await aaveLendingPool.leverageShort("0x514910771af9ca656af840dff83e8264ecf986ca", UniswapImplementation.address,AssetAmount, borrowMe, 50, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});
 
    });
    it("Should Create and Close an Insulated Position", async () => {

      let AssetAmount = new BigNumber("110000000000000")

      let initialBorrow = new BigNumber("50000000000")

      let AssetinDai = new BigNumber("30636483000000")


      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      let newInterest = new BigNumber("500000000000")

      LINK.approve(PhantasmManager.address, AssetAmount, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});
      erc20DAI.approve(PhantasmManager.address, maxApproval, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})
      /*
        address _longToken,
        uint256 _borrowFactor,
        uint256 _assetAmount,
        uint256 _initialBorrow,
        uint64 _depositId,
        uint256 stableFundAmount
      */
      await PhantasmManager.openInsulatedLongPositionNFT("0x514910771af9ca656af840dff83e8264ecf986ca", 50, AssetAmount, initialBorrow, 1, AssetinDai, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});
      
      console.log("position opened")

      const block = await web3.eth.getBlockNumber()
      await time.advanceBlockTo(block + 100)
      //     function closeInsulatedLongPosition(uint256 _tokenID, uint8 _swapImplementation, uint64 _bondImplementation) public {

      await PhantasmManager.closeInsulatedLongPosition(1,0,0,newInterest,{"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})

    })
  });
