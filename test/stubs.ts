import { BigNumber } from "@ethersproject/bignumber";
import { MockContract } from "ethereum-waffle";
import { Signer } from "@ethersproject/abstract-signer";
import { Zero } from "@ethersproject/constants";
import { waffle } from "@nomiclabs/buidler";

import Erc20Artifact from "../artifacts/Erc20.json";

const { deployMockContract: deployStubContract } = waffle;

/**
 * DEPLOYERS
 */
export async function deployStubErc20(
  deployer: Signer,
  decimals: BigNumber,
  name: string,
  symbol: string,
): Promise<MockContract> {
  const erc20: MockContract = await deployStubContract(deployer, Erc20Artifact.abi);
  await erc20.mock.decimals.returns(decimals);
  await erc20.mock.name.returns(name);
  await erc20.mock.symbol.returns(symbol);
  await erc20.mock.totalSupply.returns(Zero);
  return erc20;
}
