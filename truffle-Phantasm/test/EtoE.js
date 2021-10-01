const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");
const BigNumber = require('bignumber.js');
const IERC20 = artifacts.require("IERC20");
const Phantasm = artifacts.require("PhantasmManager");
const Uniswapper = artifacts.require("Uniswap"); 
const CompoundLender = artifacts.require("CompoundImplementation");


contract("Phantasm", (accounts) => {
    beforeEach(async () => {
      // Setup Chain env
      PhantasmManager = await Phantasm.new({"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});

      UniswapImplementation = await Uniswapper.new();

      CompoundImplementation = await CompoundLender.new();

      PhantasmManager.addSwapImplementation(UniswapImplementation.address, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});

      PhantasmManager.addLenderImplementation(CompoundImplementation.address, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});

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
      WBTC = IERC20.at("0x2260fac5e5542a773aa44fbcfedf7c193bc2c599");
      Value = new BigNumber("")
      WBTC.approve(PhantasmManager.address, 0xfffffff);
      PhantasmManager.openLongPositionNFT(0,0, "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599", 1000, 150, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    });
  });