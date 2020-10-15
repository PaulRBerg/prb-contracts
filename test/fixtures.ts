import { MockContract } from "ethereum-waffle";
import { Signer } from "@ethersproject/abstract-signer";
import { waffle } from "@nomiclabs/buidler";

import Erc20PermitArtifact from "../artifacts/Erc20Permit.json";
import Erc20RecoverArtifact from "../artifacts/GodModeErc20Recover.json";

import { DefaultNumberOfDecimals, Erc20PermitConstants } from "../utils/constants";
import { Erc20Permit } from "../typechain/Erc20Permit";
import { GodModeErc20Recover as Erc20Recover } from "../typechain/GodModeErc20Recover";

import { deployStubErc20 } from "./stubs";

const { deployContract } = waffle;

export async function erc20PermitFixture(signers: Signer[]): Promise<{ erc20Permit: Erc20Permit }> {
  const deployer: Signer = signers[0];
  const name: string = Erc20PermitConstants.name;
  const symbol: string = Erc20PermitConstants.symbol;
  const decimals = Erc20PermitConstants.decimals;
  const erc20Permit: Erc20Permit = ((await deployContract(deployer, Erc20PermitArtifact, [
    name,
    symbol,
    decimals,
  ])) as unknown) as Erc20Permit;
  return { erc20Permit };
}

export async function orchestratableFixture(signers: Signer[]): Promise<{ mainToken: string }> {
  signers;
  return { mainToken: "" };
}

export async function erc20RecoverFixture(
  signers: Signer[],
): Promise<{ erc20Recover: Erc20Recover; mainToken: MockContract; thirdPartyToken: MockContract }> {
  const deployer: Signer = signers[0];
  const mainToken: MockContract = await deployStubErc20(deployer, DefaultNumberOfDecimals, "Main Token", "MNT");
  const thirdPartyToken: MockContract = await deployStubErc20(
    deployer,
    DefaultNumberOfDecimals,
    "Third-Party Token",
    "TPT",
  );
  const erc20Recover = ((await deployContract(deployer, Erc20RecoverArtifact, [])) as unknown) as Erc20Recover;
  return { erc20Recover, mainToken, thirdPartyToken };
}
