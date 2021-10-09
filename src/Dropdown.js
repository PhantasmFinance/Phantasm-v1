import { Menu, MenuButton, MenuList, MenuItem, MenuGroup, MenuDivider, Box, Button, Image, Text, Stack } from "@chakra-ui/react";
import { ChevronDownIcon } from "@chakra-ui/icons";
import React, { useState } from "react";

export const Dropdown = ({ _type }) => {
  const daiViaAavePool = "0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E"; // Change these to an object
  const daiViaCompoundPool = "0x11B1c87983F881B3686F8b1171628357FAA30038";
  const [pool, setPool] = useState("");

  const handlePoolChange = (value) => {
    setPool(value);
  };

  return (
    <Box>
      <Menu>
        <MenuButton as={Button} rightIcon={<ChevronDownIcon />}>
          DAI Bond Pool: {pool}
        </MenuButton>
        <MenuList>
          {/* <MenuGroup title="DAI"> */}
          <MenuItem
            minH="48px"
            value={daiViaAavePool}
            onClick={(event) => {
              const selectedPool = event.currentTarget.value;
              setPool(selectedPool);
            }}
          >
            <Image boxSize="2rem" borderRadius="full" src="https://s2.coinmarketcap.com/static/img/coins/200x200/7278.png" alt="Aave" mr="12px" />
            <Stack>
              <span>Aave</span>
              <Text fontSize="xs" color="gray.500" isTruncated>
                $244,639
              </Text>
            </Stack>
          </MenuItem>
          <MenuItem
            minH="40px"
            value={daiViaCompoundPool}
            onClick={(e) => {
              const selectedPool = e.currentTarget.value;
              setPool(selectedPool);
            }}
          >
            <Image boxSize="2rem" borderRadius="full" src="https://www.economywatch.com/wp-content/uploads/2021/09/logo-8.png" alt="Compound" mr="12px" />
            <Stack>
              <span>Compound</span>
              <Text fontSize="xs" color="gray.500" isTruncated>
                $2,176
              </Text>
            </Stack>
          </MenuItem>
        </MenuList>
      </Menu>
      {pool}
    </Box>
  );
};
