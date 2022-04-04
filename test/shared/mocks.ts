import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type { MockContract } from "ethereum-waffle";
import { artifacts, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";

export async function deployMockERC20(
  deployer: SignerWithAddress,
  decimals: BigNumber,
  name: string,
  symbol: string,
): Promise<MockContract> {
  const erc20Artifact: Artifact = await artifacts.readArtifact("ERC20");
  const erc20: MockContract = await waffle.deployMockContract(deployer, erc20Artifact.abi);
  await erc20.mock.decimals.returns(decimals);
  await erc20.mock.name.returns(name);
  await erc20.mock.symbol.returns(symbol);
  await erc20.mock.totalSupply.returns(Zero);
  return erc20;
}
