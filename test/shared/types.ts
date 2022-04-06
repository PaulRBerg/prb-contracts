import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { MockContract } from "ethereum-waffle";

import type { ERC20GodMode } from "../../src/types/ERC20GodMode";
import type { ERC20Permit } from "../../src/types/ERC20Permit";
import type { ERC20RecoverGodMode } from "../../src/types/ERC20RecoverGodMode";

declare module "mocha" {
  export interface Context {
    contracts: Contracts;
    mocks: Mocks;
    signers: Signers;
  }
}

export interface Contracts {
  erc20: ERC20GodMode;
  erc20Permit: ERC20Permit;
  erc20Recover: ERC20RecoverGodMode;
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
