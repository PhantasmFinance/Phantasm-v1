import { Box, Image, Heading, Stack, Text, Button, useColorMode, Center, Slider, SliderTrack, SliderFilledTrack, SliderThumb, Flex } from "@chakra-ui/react";
import React, { useState } from "react";
import { CheckIcon, CloseIcon } from "@chakra-ui/icons";
import { PositionOption } from "./PositionOption";
import { CollateralDropdown } from "./CollateralDropdown";
import { BorrowDropdown } from "./BorrowDropdown";
import { useMoralis, useMoralisWeb3Api } from "react-moralis";
import abi from "./abi/abis.json";
import Web3 from "web3";
import abi2 from "./abi/abis88.json";

export const Profile = () => {
  const { colorMode, toggleColorMode } = useColorMode();

  const web3 = new Web3("http://127.0.0.1:8545");

  web3.eth.getAccounts().then(console.log);

  let contract = new web3.eth.Contract(abi, "0x42bcde274fbceb42d311741557c73d52a7af087e");
  let newInterest = new web3.utils.BN("50000000000000000000");

  async function closePosition() {
    const coolNumber = await contract.methods.closeInsulatedLongPosition(1, 0, 0, newInterest).send({ from: "0x28C6c06298d514Db089934071355E5743bf21d60" }).then(console.log);
    console.log("wew99");
  }

  return (
    <div>
      <Box p={3} rounded="20px" overflow="hidden" bg={colorMode === "dark" ? "gray.700" : "gray.200"} my={10} mr={5} boxShadow="dark-lg">
        <Heading mb="20px">Current Positions</Heading>
        <Box>
          <Center>
            <Flex>
              <Stack mx="25px">
                <Text as="u" fontSize="xl">
                  Asset
                </Text>
                <Center>
                  <Image boxSize="2rem" borderRadius="full" src="https://cryptologos.cc/logos/multi-collateral-dai-dai-logo.png"></Image>
                </Center>
              </Stack>
              <Stack mx="25px">
                <Text as="u" fontSize="xl">
                  Long/Short
                </Text>
                <Center>
                  <Text>Long</Text>
                </Center>
              </Stack>
              <Stack mx="25px">
                <Text as="u" fontSize="xl">
                  Insured
                </Text>
                <Center>
                  <CheckIcon />
                </Center>
              </Stack>
              <Stack mx="6px">
                <Text as="u" fontSize="xl">
                  Debt Owed
                </Text>
                <Center>
                  <Text>500</Text>
                </Center>
              </Stack>
              <Stack mx="6px">
                <Text as="u" fontSize="xl">
                  Total Collateral
                </Text>
                <Center>
                  <Text>10000</Text>
                </Center>
              </Stack>
              <Stack mx="5px">
                <Center>
                  <Text as="u" fontSize="xl">
                    Action
                  </Text>
                </Center>
                <Button variant="solid" colorScheme="red" size="sm" mt={5} boxShadow="lg" onClick={closePosition}>
                  Close Position
                </Button>
              </Stack>
            </Flex>
          </Center>
        </Box>
      </Box>
    </div>
  );
};
