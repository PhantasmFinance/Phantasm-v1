const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE } = require("./config");

const IERC20 = artifacts.require("IERC20");
const PhantasmManager = artifacts.require("PhantasmManager");

contract("PhantasmManager", (accounts) => {
  const AMOUNT_IN = 100000000;
  const wBitcoin = WBTC;
  let testUniswap;

  beforeEach(async () => {
    // make sure WHALE has enough ETH to send tx
    tokenIn = await IERC20.at("0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599");
    xSushi = await IERC20.at("0x8798249c2e607446efb7ad49ec89dd1865ff4272");
    // await sendEther(web3, accounts[0], WHALE, 1);
    testKashi = await PhantasmManager.new("0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F","0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2","0xF5BCE5077908a1b7370B9ae04AdC565EBd643966",);
    await tokenIn.approve(testKashi.address, AMOUNT_IN, { from: "0xF977814e90dA44bFA03b6295A0616a897441aceC" });
    await xSushi.approve(testKashi.address, 1000000000000, { from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});

  });

  it("Test Bridge", async () => {
    // (address _asset, uint256 _amount)
    await testKashi.bridgeOn(wBitcoin, 100000,{from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    await testKashi.bridgeOff(wBitcoin,100000, 0, {from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
  });
  
  it("Test Collateral", async () => {
    // (address _asset, uint256 _amount)
    await testKashi.bridgeOn("0x8798249c2e607446efb7ad49ec89dd1865ff4272", 100000000,{from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    // swap(address _asset1, address _asset2, uint256 _amount1, address _minOut)
    await testKashi.depositCollateral(1000, "0x3485A7C8913d640245e38564DDC05Bfb40104635",{from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    // Some bullshit with        require(_totalAsset.base >= 1000, "Kashi: below minimum");
    await testKashi.borrowLoan(6,"0x3485A7C8913d640245e38564DDC05Bfb40104635",{from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
    // Once bridge is confirmed working
  });
  /*
  it("Test SushisSwapper", async () => { 
    const TOKEN_IN = WBTC;
    const TOKEN_OUT = DAI;
    tokenIn = await IERC20.at(TOKEN_IN);
    tokenOut = await IERC20.at(TOKEN_OUT);
    const TO = accounts[0];
    await testKashi.robustSwap(tokenIn.address,tokenOut.address,AMOUNT_IN,0,TO,{from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
  });
  */
  it("Test LeveragePosition", async () => {
    // Shorting Bitcoin
    // function leveragePosition(address _asset1, uint256 _amount ,address _asset2, address _kashiPair)
    await testKashi.leveragePosition("0x8798249c2e607446efb7ad49ec89dd1865ff4272", 10000000000,"0x0000000000085d4780B73119b644AE5ecd22b376","0x3485A7C8913d640245e38564DDC05Bfb40104635",{from: "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
  });
});