const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");

const IERC20 = artifacts.require("IERC20");
const EightEight = artifacts.require("EEmph");

contract("EightEight", (accounts) => {
  const WHALE = WBTC_WHALE;
  let AMOUNT_IN = 20193159746474482760183258;
  const AMOUNT_OUT_MIN = 1;
  const TOKEN_IN = DAI;

  let dai;
  beforeEach(async () => {
    dai = await IERC20.at(TOKEN_IN);
    EightEightDeployed = await EightEight.new();

    // make sure WHALE has enough ETH to send tx
    // await sendEther(web3, accounts[0], WHALE, 1);
    AMOUNT_IN = await dai.balanceOf("0x66c57bF505A85A74609D2C83E94Aabb26d691E1F");
    await dai.approve(EightEightDeployed.address,AMOUNT_IN,{ from: "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F" });
    console.log("Contract funded");
  });

  it("should pass", async () => {
    dai.transfer(EightEightDeployed.address, AMOUNT_IN,  {from: "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});
    let stablecoins = await EightEightDeployed.buyDAITokens(2, AMOUNT_IN, {from: "0x66c57bF505A85A74609D2C83E94Aabb26d691E1F"});
    console.log(stablecoins);
  });
});