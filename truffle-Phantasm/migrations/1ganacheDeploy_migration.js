const Uniswap = artifacts.require("Uniswap"); 
const EEIntegration = artifacts.require("EEIntegration");
const AaveImplementation = artifacts.require("AaveImplementation");
const PhantasmManager = artifacts.require("PhantasmManager");
const AaveTerminal = artifacts.require("AaveTerminal")
const IERC20 = artifacts.require("IERC20");
const BigNumber = require('bignumber.js');

module.exports = async function (deployer, network) {
  // deployment steps
  await deployer.deploy(Uniswap);

  erc20DAI = await IERC20.at("0x8f3cf7ad23cd3cadbd9735aff958023239c6a063") //Polygon Correct 


  await deployer.deploy(AaveTerminal)
  aaveInterface = await AaveTerminal.deployed()

  let maxApproval = new BigNumber("99999999999999999999999999999999999999999")

  await deployer.deploy(PhantasmManager);
  await deployer.deploy(EEIntegration, PhantasmManager.address)

  EEUser = await EEIntegration.deployed()

  await deployer.deploy(AaveImplementation);

  PhantasmInstance = await PhantasmManager.deployed()

  await PhantasmInstance.addSwapImplementation(Uniswap.address)
  await PhantasmInstance.addLenderImplementation(AaveImplementation.address)
  await PhantasmInstance.addBondImplementation(EEIntegration.address)

  let blockTimeStamp = new BigNumber("1639337361")

  let daiDeposit = new BigNumber("20438906257496643008352")

  

  EEUser.makeDeposit("0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E", daiDeposit, blockTimeStamp, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"});
  
  erc20DAI.approve(AaveTerminal.address, maxApproval, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

  let AssetAmountEE = new BigNumber("11000000000000000")

  let initialBorrowEE = new BigNumber("500000000000")

  aaveInterface.depositMoney(AssetAmountEE,initialBorrowEE, {"from" : "0x5b3256965e7C3cF26E11FCAf296DfC8807C01073"})

};
