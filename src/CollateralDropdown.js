import { Menu, MenuButton, MenuList, MenuItem, MenuGroup, MenuDivider, Box, Button, Image, Text, Stack, Input, Center, Flex } from "@chakra-ui/react";
import { ChevronDownIcon } from "@chakra-ui/icons";
import React, { useState } from "react";
import { useMoralis, useMoralisWeb3Api } from "react-moralis";
import { Link } from "react-router-dom";
import { useEffect } from 'react';
import axios from 'axios';

const tokenSymbols=['USDC', 'yCRV', 'DAI', 'UNI', 'CRV:oBTC', 'CRV:HUSD', 'aLINK v1', 'crvRenWSBTC']
const onTrigger = (event) => {
  this.props.parentCallback(event.target.myname.value);
  event.preventDefault();
}

export const CollateralDropdown = () => {
  const Web3Api = useMoralisWeb3Api();

  const dai = { ticker: "DAI", address: "0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E", logo: "https://cdn.moralis.io/eth/0x6b175474e89094c44da98b954eedeac495271d0f.png" };
  const weth = { ticker: "WETH", address: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", logo: "https://cdn.moralis.io/eth/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.png" };
  const link = { ticker: "LINK", address: "0x514910771AF9Ca656af840dff83E8264EcF986CA", logo: "https://cdn.moralis.io/eth/0x514910771af9ca656af840dff83e8264ecf986ca.png" };
  const bat = { ticker: "BAT", address: "0x0D8775F648430679A709E98d2b0Cb6250d2887EF", logo: "https://cdn.moralis.io/eth/0x0d8775f648430679a709e98d2b0cb6250d2887ef.png" };
  const mkr = { ticker: "MKR", address: "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2", logo: "https://cdn.moralis.io/eth/0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2.png" };
  const yfi = { ticker: "YFI", address: "0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e", logo: "https://cryptologos.cc/logos/yearn-finance-yfi-logo.png" };
  const uni = { ticker: "UNI", address: "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", logo: "https://cdn.moralis.io/eth/0x1f9840a85d5af5bf1d1762f925bdaddc4201f984.png" };

  const [collateralToken, setCollateralToken] = useState("");
  const [amountIn, setAmountIn] = useState("");
  const [tokenAddress, setTokenAddress] = useState("");
  const [tokenBalance, setTokenBalance] = useState("");
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [items, setItems] = useState([]);

  useEffect(() => {
    const result= axios.get("https://api.88mph.app/pools",
      {
        query:  `{        
        } `
      }
      ).then(
        (result) => {
          setIsLoaded(true);
          setItems(result.data);
          for (let i = 0; i < result.data.length; i++) {
            console.log(result.data[i].tokenSymbol)
          }
        },
        (error) => {
          setIsLoaded(true);
          setError(error);
        }
      )
  }, [])

  console.log(items)



  const getTokenBalance = async (_address) => {
    const tokenBalances = await Web3Api.account.getTokenBalances();
    for (let i = 0; i < tokenBalances.length; i++) {
      if (tokenBalances[i].token_address == _address) {
        return tokenBalances.balance;
      }
    }
  };



  return (
    <Box>
      <Text as="h2" fontWeight="bold">
        SUPPLY
      </Text>
      <Box border="1px" borderColor="gray.200" borderRadius="md" p={2}>
        <Flex>
          <Menu>
            <MenuButton as={Button} w="120px" rightIcon={<ChevronDownIcon />}>
              {collateralToken}
            </MenuButton>

            <MenuList>
            {items.map((item) =>(
             <MenuItem
                minH="40px"
                value={bat.ticker}
                onClick={(event) => {
                  const selectedToken = event.currentTarget.value;
                  setCollateralToken(selectedToken);
                }}
              >
                <Stack>
                  <span>{item.tokenSymbol}</span>
                </Stack>
              </MenuItem>
            ))}

            </MenuList> 



            
          </Menu>
          <Input value={amountIn} placeholder="0.0" border="none" alignSelf="right" onChange={(event) => setAmountIn(event.currentTarget.value)} />
        </Flex>
        <Text fontSize="xs" onClick={(event) => setAmountIn({ tokenBalance })}>
          <em>
            Balance: {tokenBalance}
            {collateralToken}
          </em>
        </Text>
      </Box>

      <Center>
        <ChevronDownIcon w={16} h={16} />
      </Center>
    </Box>
  );
};
