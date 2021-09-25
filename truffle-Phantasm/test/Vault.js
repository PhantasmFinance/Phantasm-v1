const BN = require("bn.js");
const { sendEther } = require("./util");
const { DAI, WBTC, WBTC_WHALE, sUSD } = require("./config");

const IERC20 = artifacts.require("IERC20");
const Phantasm = artifacts.require("Phantasm");

contract("Phantasm", (accounts) => {

  beforeEach(async () => {
    PhantasmManager = await Phantasm.new();
  });

  it("Should Mint and Burn an NFT", async () => {
    let tokenID = PhantasmManager.createPosition();
    let result = PhantasmManager.viewPosition(tokenID);
    console.log(result)
    PhantasmManager.removePosition(tokenID);
    let result1 = PhantasmManager.viewPosition(tokenID);
    console.log(result1)
  });

});