import { BigNumber } from "@ethersproject/bignumber";

// ADDRESSES
export const addressOne: string = "0x0000000000000000000000000000000000000001";

// CHAIN IDS
export const chainIds = {
  hardhat: 31337,
  goerli: 5,
  kovan: 42,
  mainnet: 1,
  rinkeby: 4,
  ropsten: 3,
};

// CONTRACT-SPECIFIC CONSTANTS
export const erc20PermitConstants = {
  decimals: BigNumber.from(18),
  name: "Erc20 Permit",
  symbol: "ERC20",
};

// NUMBERS
export const defaultBlockGasLimit: BigNumber = BigNumber.from("10000000");
export const defaultNumberOfDecimals: BigNumber = BigNumber.from(18);
export const unitsPerToken: BigNumber = BigNumber.from("1000000000000000000");

export const oneToken: BigNumber = unitsPerToken;
export const oneHundredTokens: BigNumber = oneToken.mul(100);

// PRIVATE KEYS
export const defaultPrivateKeys = {
  alice: "0x680bbcc848b8d7154309c60604ce24663455068bd6258aeda48dbf9429f93c92",
  bob: "0x61d459a2d39217fba15c860cd0bb0e1188d683d3f2acb5dd1136f34ed92ddac4",
  carol: "0xce4ea5d18394cc9a3d98646836ee1908e053ff835ddb7fc671c21b48accb148e",
  david: "0x9e43994c4dc96052aa05bcf393a6953385d599843106c013c9935d05fd19583e",
  eve: "0x6b4dfca6605c23e5a4c18dcaaadc1b394f89cbb82678be0ba9bb685dd75d0d14",
};
