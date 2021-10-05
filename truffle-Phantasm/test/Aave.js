const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");
const BigNumber = require('bignumber.js');
const IERC20 = artifacts.require("IERC20");
const Uniswapper = artifacts.require("Uniswap"); 

const AaveLender = artifacts.require("AaveImplementation");


contract("AaveLender", (accounts) => {
    beforeEach(async () => {
      // Setup Chain env

      LINK = await IERC20.at("0x514910771af9ca656af840dff83e8264ecf986ca");

      erc20DAI = await IERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F") 
      

      UniswapImplementation = await Uniswapper.new();

      aaveLendingPool = await AaveLender.new();


    });
  

    it("Create a Long Position", async () => {
      // Iterative Tests here
      /*
    function leverageLong(address _asset, address _swapper, uint256 _initialAmount, uint256 _borrowFactor) external returns (uint256, uint256) {

      */

      let AssetAmount = new BigNumber("11000000000000000000000")

      LINK.approve(aaveLendingPool.address, AssetAmount, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"})

      await aaveLendingPool.leverageLong("0x514910771af9ca656af840dff83e8264ecf986ca",UniswapImplementation.address, AssetAmount, 50, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    });

    it("Create a Short Position", async () => {
      // Iterative Tests here
      /*
    function leverageLong(address _asset, address _swapper, uint256 _initialAmount, uint256 _borrowFactor) external returns (uint256, uint256) {

      */

      let AssetAmount = new BigNumber("11000000000000000000000")

      LINK.approve(aaveLendingPool.address, AssetAmount, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"})

      await aaveLendingPool.leverageShort("0x514910771af9ca656af840dff83e8264ecf986ca",UniswapImplementation.address, AssetAmount, 50, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    });

  });