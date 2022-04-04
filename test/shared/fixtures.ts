import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { MockContract } from "ethereum-waffle";
import { artifacts, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";

import {
  DEFAULT_DECIMALS,
  ERC20_DECIMALS,
  ERC20_NAME,
  ERC20_PERMIT_DECIMALS,
  ERC20_PERMIT_NAME,
  ERC20_PERMIT_SYMBOL,
  ERC20_SYMBOL,
} from "../../helpers/constants";
import type { ERC20Permit } from "../../src/types/ERC20Permit";
import type { GodModeERC20 as ERC20 } from "../../src/types/GodModeERC20";
import type { GodModeERC20Recover as ERC20Recover } from "../../src/types/GodModeERC20Recover";
import { deployMockERC20 } from "./mocks";

export async function erc20Fixture(signers: SignerWithAddress[]): Promise<{ erc20: ERC20 }> {
  const deployer: SignerWithAddress = signers[0];
  const godModeERC20Artifact: Artifact = await artifacts.readArtifact("GodModeERC20");
  const erc20: ERC20 = <ERC20>(
    await waffle.deployContract(deployer, godModeERC20Artifact, [ERC20_NAME, ERC20_SYMBOL, ERC20_DECIMALS])
  );
  return { erc20 };
}

export async function erc20PermitFixture(signers: SignerWithAddress[]): Promise<{ erc20Permit: ERC20Permit }> {
  const deployer: SignerWithAddress = signers[0];
  const erc20PermitArtifact: Artifact = await artifacts.readArtifact("ERC20Permit");
  const erc20Permit: ERC20Permit = <ERC20Permit>(
    await waffle.deployContract(deployer, erc20PermitArtifact, [
      ERC20_PERMIT_NAME,
      ERC20_PERMIT_SYMBOL,
      ERC20_PERMIT_DECIMALS,
    ])
  );
  return { erc20Permit };
}

export async function erc20RecoverFixture(
  signers: SignerWithAddress[],
): Promise<{ erc20Recover: ERC20Recover; mainToken: MockContract; thirdPartyToken: MockContract }> {
  const deployer: SignerWithAddress = signers[0];
  const mainToken: MockContract = await deployMockERC20(deployer, DEFAULT_DECIMALS, "Main Token", "MNT");
  const thirdPartyToken: MockContract = await deployMockERC20(deployer, DEFAULT_DECIMALS, "Third-Party Token", "TPT");

  const godModeERC20Recover: Artifact = await artifacts.readArtifact("GodModeERC20Recover");
  const erc20Recover: ERC20Recover = <ERC20Recover>await waffle.deployContract(deployer, godModeERC20Recover, []);
  return { erc20Recover, mainToken, thirdPartyToken };
}
