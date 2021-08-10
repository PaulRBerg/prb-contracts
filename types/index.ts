import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { MockContract } from "ethereum-waffle";

//import { Erc20 } from "../typechain/Erc20";
import { Erc20Permit } from "../typechain/Erc20Permit";
import { GodModeErc20Recover as Erc20Recover } from "../typechain/GodModeErc20Recover";
import { GodModeErc20 as Erc20 } from "../typechain/GodModeErc20";

export interface Contracts {
  erc20: Erc20;
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

export interface Mocks {
  mainToken: MockContract;
  thirdPartyToken: MockContract;
}
