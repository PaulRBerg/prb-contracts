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
import type { ERC20GodMode as ERC20 } from "../../src/types/ERC20GodMode";
import type { ERC20Permit } from "../../src/types/ERC20Permit";
import type { ERC20RecoverGodMode as ERC20Recover } from "../../src/types/ERC20RecoverGodMode";
import { deployMockERC20 } from "./mocks";

export async function erc20Fixture(signers: SignerWithAddress[]): Promise<{ erc20: ERC20 }> {
  const deployer: SignerWithAddress = signers[0];
  const godModeERC20Artifact: Artifact = await artifacts.readArtifact("ERC20GodMode");
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

  const erc20RecoverGodModeArtifact: Artifact = await artifacts.readArtifact("ERC20RecoverGodMode");
  const erc20Recover: ERC20Recover = <ERC20Recover>(
    await waffle.deployContract(deployer, erc20RecoverGodModeArtifact, [])
  );
  return { erc20Recover, mainToken, thirdPartyToken };
}
