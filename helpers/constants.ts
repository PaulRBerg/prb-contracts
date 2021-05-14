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
export const bobPrivateKey: string = "0xd0792a518700b34f3cf29d533f1d8bb81262eabca4f1817212a5044ee866c3a6";
