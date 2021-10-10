import { Box, Image, Stack, Badge, Text, Button, useColorMode, Center, Slider, SliderTrack, SliderFilledTrack, SliderThumb, Flex } from "@chakra-ui/react";
import React, { useState } from "react";
import { ChevronRightIcon } from "@chakra-ui/icons";
import { PositionOption } from "./PositionOption";
import { CollateralDropdown } from "./CollateralDropdown";
import { BorrowDropdown } from "./BorrowDropdown";
import { useMoralis, Moralis } from "react-moralis";
import abi from './abi/abis.json'
import Web3 from 'web3';
import abi2 from './abi/abis88.json'



export const MainCard = ({ _asset, _protocol, _totalTokensLocked, _totalUSDLocked }) => {
  const compoundColorScheme = "green";
  const aaveColorScheme = "purple";
  const daiViaAavePool = "0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E";
  const daiViaCompoundPool = "0x11B1c87983F881B3686F8b1171628357FAA30038";
  const [pool, setPool] = useState("");



  const handlePoolChange = (value) => {
    setPool(value);
  };
  const { colorMode, toggleColorMode } = useColorMode();
  const [leverageAmount, setLeverageAmount] = useState(0);
  const percentAmount = leverageAmount * 100;
  
  const state = {
    name: "",
  }
  const handleCallback= (childData) => {
    this.setState({name:childData})
  }
   
  const web3 = new Web3('http://127.0.0.1:8545');

  web3.eth.getAccounts().then(console.log)

  let AssetAmount = new web3.utils.BN("11000000000000000000000")

  let initialBorrow = new web3.utils.BN("50000000000000000000")

  let maxApproval =  new web3.utils.BN("99999999999999999999999999999999999999999")

  let newInterest = new web3.utils.BN("50000000000000000000")

  let AssetinDai = new web3.utils.BN("306364830000000000000000")


  let AssetAmountEE = new web3.utils.BN("11000000000000000")

  let initialBorrowEE = new web3.utils.BN("500000000000")

  let contract = new web3.eth.Contract(abi, '0x42bcde274fbceb42d311741557c73d52a7af087e')
  let contract88 = new web3.eth.Contract(abi2, '0x42bcde274fbceb42d311741557c73d52a7af087e')

  
  async function openlong() {
    const coolNumber = await contract.methods.openInsulatedLongPositionNFT("0x514910771af9ca656af840dff83e8264ecf986ca", 50, AssetAmount, initialBorrow, 1, AssetinDai)
  .send({ from: "0x0A9903B08c7cCb1E25e5488E1001e2ADED1cD92D" }).then(console.log)
  }

  async function makedeposit() {
    const coolNumber = await contract88.methods.makeDeposit("0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E", maxApproval, newInterest)
  .send({ from: "0x42bcde274fbceb42d311741557c73d52a7af087e" }).then(console.log)
  console.log("wew99")
  }

  async function closelong() {
    const coolNumber = await contract.methods.closeLongPosition(1, 0, newInterest)
  .send({ from: "0x42bcde274fbceb42d311741557c73d52a7af087e" }).then(console.log)
  console.log("wew99")
  }

  return (
    <div className="app">
      <Box rounded="20px" overflow="hidden" bg={colorMode === "dark" ? "gray.700" : "gray.200"} mt={10} mr={5} boxShadow="dark-lg">
        <Center>
          <Image src="https://s2.coinmarketcap.com/static/img/coins/200x200/4943.png" alt="Card Image" boxSize="80px" mt={5}></Image>
          <ChevronRightIcon w={8} h={8} mt={5} />
          <Image src="https://cryptologos.cc/logos/aave-aave-logo.png" alt="Card Image" boxSize="80px" mt={5}></Image>
        </Center>
        <Box p={5}>
          <Stack align="center">
            <Badge variant="solid" colorMode="light" colorScheme="yellow" rounded="full" px={2}>
              Asset: {_asset}
            </Badge>
            <Badge variant="solid" colorScheme={compoundColorScheme} rounded="full" px={2}>
              Protocol: {_protocol}
            </Badge>
          </Stack>
          <Stack align="center">
            <Text as="h2" fontWeight="bold" mt={5}>
              Total Locked
              <br />
              {_totalTokensLocked}
              {_asset}
            </Text>
            <Text fontWeight="light">${_totalUSDLocked}</Text>
          </Stack>

          <CollateralDropdown />


          <BorrowDropdown />

          <PositionOption />
          <Text as="h2" fontWeight="normal" mt={5}>
            Leverage: {percentAmount}%
          </Text>
          <Slider
            aria-label="card-leverage-slider"
            defaultValue={0}
            min={0}
            max={0.6}
            step={0.05}
            mt={2}
            onChange={(val) => {
              const currentLeverageAmount = val;
              setLeverageAmount(currentLeverageAmount);
            }}
          >
            <SliderTrack bg="green.100">
              <Box position="relative" right={10} />
              <SliderFilledTrack bg={compoundColorScheme} />
            </SliderTrack>
            <SliderThumb boxSize={6} />
          </Slider>
          <Center>
            <Button onClick={openlong}  variant="solid" colorScheme="green" size="sm" mt={5} boxShadow="lg">
              Enter Position
            </Button>
          </Center>
        </Box>
      </Box>
    </div>
  );
};
