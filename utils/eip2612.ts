import { BigNumber } from "@ethersproject/bignumber";
import { defaultAbiCoder } from "@ethersproject/abi";
import { keccak256 } from "@ethersproject/keccak256";
import { pack as solidityPack } from "@ethersproject/solidity";
import { toUtf8Bytes } from "@ethersproject/strings";

import { Erc20Permit } from "../typechain/Erc20Permit";

/* Must match the typehash in Erc20PermitStorage.sol */
export const PERMIT_TYPEHASH: string = keccak256(
  toUtf8Bytes("Permit(address owner,address spender,uint256 amount,uint256 nonce,uint256 deadline)"),
);

/* Must match the version in Erc20PermitStorage.sol */
export const version: string = "1";

/**
 * Returns the Eip712 domain separator.
 */
export function getDomainSeparator(name: string, chainId: number, tokenAddress: string): string {
  return keccak256(
    defaultAbiCoder.encode(
      ["bytes32", "bytes32", "bytes32", "uint256", "address"],
      [
        keccak256(toUtf8Bytes("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")),
        keccak256(toUtf8Bytes(name)),
        keccak256(toUtf8Bytes(version)),
        chainId,
        tokenAddress,
      ],
    ),
  );
}

/**
 * Returns the Eip712 hash that must be signed by the user in order to
 * make a call to `permit`.
 */
export async function getPermitDigest(
  token: Erc20Permit,
  chainId: BigNumber,
  approve: {
    owner: string;
    spender: string;
    amount: BigNumber;
  },
  nonce: BigNumber,
  deadline: BigNumber,
): Promise<string> {
  const tokenName = await token.name();
  const DOMAIN_SEPARATOR = getDomainSeparator(tokenName, chainId.toNumber(), token.address);
  return keccak256(
    solidityPack(
      ["bytes1", "bytes1", "bytes32", "bytes32"],
      [
        "0x19",
        "0x01",
        DOMAIN_SEPARATOR,
        keccak256(
          defaultAbiCoder.encode(
            ["bytes32", "address", "address", "uint256", "uint256", "uint256"],
            [PERMIT_TYPEHASH, approve.owner, approve.spender, approve.amount, nonce, deadline],
          ),
        ),
      ],
    ),
  );
}
