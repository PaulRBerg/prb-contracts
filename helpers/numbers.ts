import { BigNumber } from "@ethersproject/bignumber";
import fp from "evm-fp";
import fromExponential from "from-exponential";

export function bn(x: string): BigNumber {
  let xs: string = x;
  if (x.includes("e")) {
    xs = fromExponential(x);
  }
  return BigNumber.from(xs);
}
export function token(x: string): BigNumber {
  return fp(x, 18);
}
