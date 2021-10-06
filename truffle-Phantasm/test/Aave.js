const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");
const BigNumber = require('bignumber.js');
const IERC20 = artifacts.require("IERC20");
const Uniswapper = artifacts.require("Uniswap"); 
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

      LINK = await IERC20.at("0x514910771af9ca656af840dff83e8264ecf986ca");

      erc20DAI = await IERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F") 
      
      UniswapImplementation = await Uniswapper.new();

      await PhantasmManager.addSwapImplementation(UniswapImplementation.address, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      await PhantasmManager.addLenderImplementation(aaveLendingPool.address, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

    });
  

    it("Create a Long Position", async () => {
      // Iterative Tests here
      /*
    function leverageLong(address _asset, address _swapper, uint256 _initialAmount, uint256 _borrowFactor) external returns (uint256, uint256) {

      */

      let AssetAmount = new BigNumber("11000000000000000000000")

      LINK.approve(aaveLendingPool.address, AssetAmount, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})

      let borrowMe = new BigNumber("100000000000000000000")

      let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

      LINK.approve(PhantasmManager.address, AssetAmount, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});

      await PhantasmManager.openLongPositionNFT(0,0, "0x514910771af9ca656af840dff83e8264ecf986ca", 50, AssetAmount, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"});
      
      console.log("position opened")

      erc20DAI.approve(PhantasmManager.address,maxApproval,{"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"} )

      await PhantasmManager.closeLongPosition(1, 0, {"from" : "0x28C6c06298d514Db089934071355E5743bf21d60"})

 
    });

  });
