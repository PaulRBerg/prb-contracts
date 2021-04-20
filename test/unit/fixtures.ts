import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { MockContract } from "ethereum-waffle";
import hre from "hardhat";
import { Artifact } from "hardhat/types";

import { defaultNumberOfDecimals, erc20PermitConstants } from "../../helpers/constants";
import { Erc20Permit } from "../../typechain/Erc20Permit";
import { GodModeErc20Recover as Erc20Recover } from "../../typechain/GodModeErc20Recover";
import { deployStubErc20 } from "./stubs";

const { deployContract } = hre.waffle;

export async function erc20PermitFixture(signers: SignerWithAddress[]): Promise<{ erc20Permit: Erc20Permit }> {
  const deployer: SignerWithAddress = signers[0];
  const name: string = erc20PermitConstants.name;
  const symbol: string = erc20PermitConstants.symbol;
  const decimals = erc20PermitConstants.decimals;

  const erc20PermitArtifact: Artifact = await hre.artifacts.readArtifact("Erc20Permit");
  const erc20Permit: Erc20Permit = <Erc20Permit>(
    await deployContract(deployer, erc20PermitArtifact, [name, symbol, decimals])
  );
  return { erc20Permit };
}

export async function orchestratableFixture(signers: SignerWithAddress[]): Promise<{ mainToken: string }> {
  signers;
  return { mainToken: "" };
}

export async function erc20RecoverFixture(
  signers: SignerWithAddress[],
): Promise<{ erc20Recover: Erc20Recover; mainToken: MockContract; thirdPartyToken: MockContract }> {
  const deployer: SignerWithAddress = signers[0];
  const mainToken: MockContract = await deployStubErc20(deployer, defaultNumberOfDecimals, "Main Token", "MNT");
  const thirdPartyToken: MockContract = await deployStubErc20(
    deployer,
    defaultNumberOfDecimals,
    "Third-Party Token",
    "TPT",
  );

  const godModeErc20Recover: Artifact = await hre.artifacts.readArtifact("GodModeErc20Recover");
  const erc20Recover: Erc20Recover = <Erc20Recover>await deployContract(deployer, godModeErc20Recover, []);
  return { erc20Recover, mainToken, thirdPartyToken };
}
