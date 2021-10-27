import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { MockContract } from "ethereum-waffle";

import type { Erc20Permit } from "../../src/types/Erc20Permit";
import type { GodModeErc20 } from "../../src/types/GodModeErc20";
import type { GodModeErc20Recover } from "../../src/types/GodModeErc20Recover";

declare module "mocha" {
  export interface Context {
    contracts: Contracts;
    mocks: Mocks;
    signers: Signers;
  }
}

export interface Contracts {
  erc20: GodModeErc20;
  erc20Permit: Erc20Permit;
  erc20Recover: GodModeErc20Recover;
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
