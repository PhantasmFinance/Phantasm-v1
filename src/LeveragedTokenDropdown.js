import { Menu, MenuButton, MenuList, MenuItem, MenuGroup, MenuDivider, Box, Button, Image, Text, Stack, Input, Center, Flex, Heading } from "@chakra-ui/react";
import { ChevronDownIcon } from "@chakra-ui/icons";
import React, { useState } from "react";
import { useMoralis, useMoralisWeb3Api } from "react-moralis";
import { Link } from "react-router-dom";

export const LeveragedTokenDropdown = ({ leveragedToken, setLeveragedToken, leveragedLogo, setLeveragedLogo, leveragedLogoChange }) => {
  const dai = { ticker: "DAI", address: "0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E", logo: "https://cdn.moralis.io/eth/0x6b175474e89094c44da98b954eedeac495271d0f.png" };
  const weth = { ticker: "WETH", address: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", logo: "https://cdn.moralis.io/eth/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.png" };
  const link = { ticker: "LINK", address: "0x514910771AF9Ca656af840dff83E8264EcF986CA", logo: "https://cdn.moralis.io/eth/0x514910771af9ca656af840dff83e8264ecf986ca.png" };
  const bat = { ticker: "BAT", address: "0x0D8775F648430679A709E98d2b0Cb6250d2887EF", logo: "https://cdn.moralis.io/eth/0x0d8775f648430679a709e98d2b0cb6250d2887ef.png" };
  const mkr = { ticker: "MKR", address: "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2", logo: "https://cdn.moralis.io/eth/0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2.png" };
  const yfi = { ticker: "YFI", address: "0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e", logo: "https://cryptologos.cc/logos/yearn-finance-yfi-logo.png" };
  const uni = { ticker: "UNI", address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", logo: "https://cdn.moralis.io/eth/0x1f9840a85d5af5bf1d1762f925bdaddc4201f984.png" };

  //const { Moralis } = useMoralisWeb3Api();
  const Web3Api = useMoralisWeb3Api();

  const getBalances = async () => {
    const userBalance = await Web3Api.account.getTokenBalances();
  };

  const getLogo = async (_symbol) => {
    await Web3Api.token.getTokenMetadataBySymbol({ symbols: _symbol }).logo;
  };

  return (
    <Box>
      <Text as="h2" fontWeight="bold" mb={2}>
        LEVERAGED ASSET
      </Text>
      <Flex>
        <Menu>
          <MenuButton as={Button} w="100%" rightIcon={<ChevronDownIcon />} colorScheme="blue" bgGradient="linear(to-r, #9D8DF1, #B8CDF8, #1CFEBA)" p={5} minHeight={16} h={30}>
            <Flex>
              <Image src={leveragedLogo} boxSize={6} mr={3} />
              <Text mt={0.5}>{leveragedToken}</Text>
            </Flex>
          </MenuButton>
          <MenuList>
            <MenuItem
              minH="48px"
              value={dai.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(dai);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={dai.logo} alt="Dai" mr="12px" />
              <Stack>
                <span>DAI</span>
              </Stack>
            </MenuItem>
            <MenuItem
              minH="48px"
              value={weth.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(weth);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={weth.logo} alt="Aave" mr="12px" />
              <Stack>
                <span>WETH</span>
              </Stack>
            </MenuItem>
            <MenuItem
              minH="40px"
              value={link.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(link);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={link.logo} alt="Compound" mr="12px" />
              <Stack>
                <span>LINK</span>
              </Stack>
            </MenuItem>
            <MenuItem
              minH="40px"
              value={bat.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(bat);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={bat.logo} alt="Compound" mr="12px" />
              <Stack>
                <span>BAT</span>
              </Stack>
            </MenuItem>
            <MenuItem
              minH="40px"
              value={mkr.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(mkr);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={mkr.logo} alt="Compound" mr="12px" />
              <Stack>
                <span>MKR</span>
              </Stack>
            </MenuItem>
            <MenuItem
              minH="40px"
              value={yfi.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(yfi);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={yfi.logo} alt="Compound" mr="12px" />
              <Stack>
                <span>YFI</span>
              </Stack>
            </MenuItem>
            <MenuItem
              minH="40px"
              value={uni.ticker}
              onClick={(event) => {
                const selectedToken = event.currentTarget.value;
                setLeveragedToken(selectedToken);
                leveragedLogoChange(uni);
              }}
            >
              <Image boxSize="2rem" borderRadius="full" src={uni.logo} alt="Compound" mr="12px" />
              <Stack>
                <span>UNI</span>
              </Stack>
            </MenuItem>
          </MenuList>
        </Menu>
      </Flex>
    </Box>
  );
};
