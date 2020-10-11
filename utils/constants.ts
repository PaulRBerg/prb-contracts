import { BigNumber } from "@ethersproject/bignumber";

/**
 * ADDRESSES
 */
export const AddressOne: string = "0x0000000000000000000000000000000000000001";

/**
 * CHAIN IDs
 */
export const ChainIds = {
  BuidlerEvm: 31337,
  Ganache: 1337,
  Goerli: 5,
  Kovan: 42,
  Mainnet: 1,
  Rinkeby: 4,
  Ropsten: 3,
};

/**
 * CONTRACT-SPECIFIC CONSTANTS
 */
export const Erc20PermitConstants = {
  decimals: BigNumber.from(18),
  name: "Erc20 Permit",
  symbol: "ERC20",
};

/**
 * NUMBERS
 */
export const DefaultBlockGasLimit: BigNumber = BigNumber.from("10000000");
export const DefaultNumberOfDecimals: BigNumber = BigNumber.from(18);
export const UnitsPerToken: BigNumber = BigNumber.from("1000000000000000000");

// export const OnePercentMantissa: BigNumber = BigNumber.from("10000000000000000");
// export const OneHundredPercentMantissa: BigNumber = OnePercentMantissa.mul(100);
// export const OneHundredAndFiftyPercentMantissa: BigNumber = OnePercentMantissa.mul(150);
// export const OneThousandPercentMantissa: BigNumber = OnePercentMantissa.mul(1000);
// export const TenThousandPercentMantissa: BigNumber = OnePercentMantissa.mul(10000);

export const OneToken: BigNumber = UnitsPerToken;
// export const TenTokens: BigNumber = OneToken.mul(10);
export const OneHundredTokens: BigNumber = OneToken.mul(100);
// export const OneThousandTokens: BigNumber = OneToken.mul(1000);
// export const OneMillionTokens: BigNumber = OneToken.mul(1000000);

/**
 * PRIVATE KEYS
 */
export const DefaultPrivateKeys = {
  Alice: "0x680bbcc848b8d7154309c60604ce24663455068bd6258aeda48dbf9429f93c92",
  Bob: "0x61d459a2d39217fba15c860cd0bb0e1188d683d3f2acb5dd1136f34ed92ddac4",
  Carol: "0xce4ea5d18394cc9a3d98646836ee1908e053ff835ddb7fc671c21b48accb148e",
  David: "0x9e43994c4dc96052aa05bcf393a6953385d599843106c013c9935d05fd19583e",
  Eve: "0x6b4dfca6605c23e5a4c18dcaaadc1b394f89cbb82678be0ba9bb685dd75d0d14",
};
