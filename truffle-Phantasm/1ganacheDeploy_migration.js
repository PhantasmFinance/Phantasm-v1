const Uniswap = artifacts.require("Uniswap"); 
const EEIntegration = artifacts.require("EEIntegration");
const AaveImplementation = artifacts.require("AaveImplementation");
const PhantasmManager = artifacts.require("PhantasmManager");

module.exports = async function (deployer, network) {
  // deployment steps
  await deployer.deploy(Uniswap);


  await deployer.deploy(PhantasmManager);
  await deployer.deploy(EEIntegration, PhantasmManager.address)
  await deployer.deploy(AaveImplementation);

  PhantasmInstance = await PhantasmManager.deployed()

  await PhantasmInstance.addSwapImplementation(Uniswap.address)
  await PhantasmInstance.addLenderImplementation(AaveImplementation.address)
  await PhantasmInstance.addBondImplementation(EEIntegration.address)

};
