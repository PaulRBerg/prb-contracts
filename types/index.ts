import { MockContract } from "ethereum-waffle";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import { Erc20Permit } from "../typechain/Erc20Permit";
import { GodModeErc20Recover as Erc20Recover } from "../typechain/GodModeErc20Recover";

export interface Contracts {
  erc20Permit: Erc20Permit;
  erc20Recover: Erc20Recover;
}

export interface Signers {
  alice: SignerWithAddress;
  bob: SignerWithAddress;
  carol: SignerWithAddress;
  david: SignerWithAddress;
  eve: SignerWithAddress;
}

export interface Stubs {
  mainToken: MockContract;
  thirdPartyToken: MockContract;
}
