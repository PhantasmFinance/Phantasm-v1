const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");
const BigNumber = require('bignumber.js');
const IERC20 = artifacts.require("IERC20");
const Phantasm = artifacts.require("PhantasmManager");
const Uniswapper = artifacts.require("Uniswap"); 
const CErc20 = artifacts.require("CErc20"); 

const CompoundLender = artifacts.require("CompoundImplementation");


contract("Phantasm", (accounts) => {
    beforeEach(async () => {
      // Setup Chain env
      PhantasmManager = await Phantasm.new({"from" : "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});

      erc20WBTC = await IERC20.at("0x2260fac5e5542a773aa44fbcfedf7c193bc2c599");

      erc20DAI = await IERC20.at("0x6B175474E89094C44Da98b954EedeAC495271d0F") 
      
      cerc20DAI = await CErc20.at("0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643")

      UniswapImplementation = await Uniswapper.new();

      CompoundImplementation = await CompoundLender.new();

      await PhantasmManager.addSwapImplementation(UniswapImplementation.address, {"from" : "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});

      await PhantasmManager.addLenderImplementation(CompoundImplementation.address, {"from" : "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});

    });
  

    it("Create a Long Position", async () => {
      // Iterative Tests here
      /*
        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _longToken,
        uint256 _borrowAmount,
        uint256 _borrowFactor
      */
      let borrowMe = new BigNumber("100000000000000000000")


      let AssetAmount = new BigNumber("11000000000000000000000")

      erc20DAI.approve(PhantasmManager.address, AssetAmount, {"from" : "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});


      await PhantasmManager.openLongPositionNFT(0,0, "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599", borrowMe, 50, AssetAmount ,{"from" : "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});
    });
  });
