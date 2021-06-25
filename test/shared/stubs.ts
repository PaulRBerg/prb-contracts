import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { MockContract } from "ethereum-waffle";
import hre from "hardhat";
import { Artifact } from "hardhat/types";

const { deployMockContract: deployStubContract } = hre.waffle;

export async function deployStubErc20(
  deployer: SignerWithAddress,
  decimals: BigNumber,
  name: string,
  symbol: string,
): Promise<MockContract> {
  const erc20Artifact: Artifact = await hre.artifacts.readArtifact("Erc20");
  const erc20: MockContract = await deployStubContract(deployer, erc20Artifact.abi);
  await erc20.mock.decimals.returns(decimals);
  await erc20.mock.name.returns(name);
  await erc20.mock.symbol.returns(symbol);
  await erc20.mock.totalSupply.returns(Zero);
  return erc20;
}
