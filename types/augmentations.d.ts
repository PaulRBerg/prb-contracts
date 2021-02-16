import { Contracts, Signers, Stubs } from "./";

declare module "mocha" {
  export interface Context {
    contracts: Contracts;
    signers: Signers;
    stubs: Stubs;
  }
}
