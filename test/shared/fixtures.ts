import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { MockContract } from "ethereum-waffle";
import { artifacts, waffle } from "hardhat";
import { Artifact } from "hardhat/types";

import {
  DEFAULT_DECIMALS,
  ERC20_PERMIT_DECIMALS,
  ERC20_PERMIT_NAME,
  ERC20_PERMIT_SYMBOL,
  ERC20_DECIMALS,
  ERC20_NAME,
  ERC20_SYMBOL,
} from "../../helpers/constants";
import { Erc20Permit } from "../../typechain/Erc20Permit";
import { GodModeErc20Recover as Erc20Recover } from "../../typechain/GodModeErc20Recover";
import { GodModeErc20 as Erc20 } from "../../typechain/GodModeErc20";
import { deployMockErc20 } from "./mocks";

const { deployContract } = waffle;

export async function erc20PermitFixture(signers: SignerWithAddress[]): Promise<{ erc20Permit: Erc20Permit }> {
  const deployer: SignerWithAddress = signers[0];
  const erc20PermitArtifact: Artifact = await artifacts.readArtifact("Erc20Permit");
  const erc20Permit: Erc20Permit = <Erc20Permit>(
    await deployContract(deployer, erc20PermitArtifact, [ERC20_PERMIT_NAME, ERC20_PERMIT_SYMBOL, ERC20_PERMIT_DECIMALS])
  );
  return { erc20Permit };
}

export async function erc20RecoverFixture(
  signers: SignerWithAddress[],
): Promise<{ erc20Recover: Erc20Recover; mainToken: MockContract; thirdPartyToken: MockContract }> {
  const deployer: SignerWithAddress = signers[0];
  const mainToken: MockContract = await deployMockErc20(deployer, DEFAULT_DECIMALS, "Main Token", "MNT");
  const thirdPartyToken: MockContract = await deployMockErc20(deployer, DEFAULT_DECIMALS, "Third-Party Token", "TPT");

  const godModeErc20Recover: Artifact = await artifacts.readArtifact("GodModeErc20Recover");
  const erc20Recover: Erc20Recover = <Erc20Recover>await deployContract(deployer, godModeErc20Recover, []);
  return { erc20Recover, mainToken, thirdPartyToken };
}

export async function erc20Fixture(signers: SignerWithAddress[]): Promise<{ erc20: Erc20 }> {
  const deployer: SignerWithAddress = signers[0];
  const godModeErc20Artifact: Artifact = await artifacts.readArtifact("GodModeErc20");
  const erc20: Erc20 = <Erc20>(
    await deployContract(deployer, godModeErc20Artifact, [ERC20_NAME, ERC20_SYMBOL, ERC20_DECIMALS])
  );
  return { erc20 };
}
