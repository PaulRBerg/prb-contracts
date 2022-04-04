import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { MockContract } from "ethereum-waffle";

import type { ERC20Permit } from "../../src/types/ERC20Permit";
import type { GodModeERC20 } from "../../src/types/GodModeERC20";
import type { GodModeERC20Recover } from "../../src/types/GodModeERC20Recover";

declare module "mocha" {
  export interface Context {
    contracts: Contracts;
    mocks: Mocks;
    signers: Signers;
  }
}

export interface Contracts {
  erc20: GodModeERC20;
  erc20Permit: ERC20Permit;
  erc20Recover: GodModeERC20Recover;
}

export interface Signers {
  alice: SignerWithAddress;
  bob: SignerWithAddress;
  carol: SignerWithAddress;
  david: SignerWithAddress;
  eve: SignerWithAddress;
}

export interface Mocks {
  mainToken: MockContract;
  thirdPartyToken: MockContract;
}
