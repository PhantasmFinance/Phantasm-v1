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

      LINK = await IERC20.at("0x514910771af9ca656af840dff83e8264ecf986ca");

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

      LINK.approve(PhantasmManager.address, AssetAmount, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});


      await PhantasmManager.openLongPositionNFT(0,0, "0x514910771af9ca656af840dff83e8264ecf986ca", "0xface851a4921ce59e912d19329929ce6da6eb0c7", borrowMe, 50, AssetAmount, ["0x6b175474e89094c44da98b954eedeac495271d0f", "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "0xface851a4921ce59e912d19329929ce6da6eb0c7"], {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
      
      console.log(`Balance of Loan taken = ${await LINK.balanceOf(PhantasmManager.address, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"})}`)

      console.log(`Balance of Loan taken = ${await PhantasmManager.viewPosition(1, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"})}`)

    });

    /*
    it("Create a Long Position and Close it", async () => {
      // Iterative Tests here
\        uint64 _lenderImplementation, 
        uint64 _swapImplementation,
        address _longToken,
        uint256 _borrowAmount,
        uint256 _borrowFactor
      let borrowMe = new BigNumber("100000000000000000000")




      let AssetAmount = new BigNumber("11000000000000000000000")

      LINK.approve(PhantasmManager.address, AssetAmount, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});


      await PhantasmManager.openLongPositionNFT(0,0, "0x514910771af9ca656af840dff83e8264ecf986ca", "0xface851a4921ce59e912d19329929ce6da6eb0c7", borrowMe, 50, AssetAmount ,{"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"});
      

      console.log("Position Opened, time to close it")
      
      //    function closeLongPosition(uint256 _tokenID, address _borrowedCToken, address _collateralCToken, uint8 _swapImplementation) public {
      await PhantasmManager.closeLongPosition(1,"0xFAce851a4921ce59e912d19329929CE6da6EB0c7", "0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643", 0, {"from" : "0xF977814e90dA44bFA03b6295A0616a897441aceC"})
    });
      */

  });