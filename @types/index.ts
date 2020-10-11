import { MockContract } from "ethereum-waffle";
import { Signer } from "@ethersproject/abstract-signer";

import { Erc20Permit } from "../typechain/Erc20Permit";
import { GodModeErc20Recover as Erc20Recover } from "../typechain/GodModeErc20Recover";

/* Fingers-crossed that ethers.js or waffle will provide an easier way to cache the address */
export interface Accounts {
  alice: string;
  bob: string;
  carol: string;
  david: string;
  eve: string;
}

export interface Contracts {
  erc20Permit: Erc20Permit;
  erc20Recover: Erc20Recover;
}

export interface Signers {
  admin: Signer;
  brad: Signer;
  eve: Signer;
  grace: Signer;
  lucy: Signer;
  mark: Signer;
}

export interface Stubs {
  mainToken: MockContract;
  thirdPartyToken: MockContract;
}
