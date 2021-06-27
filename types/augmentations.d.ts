import { Contracts, Mocks, Signers } from "./";

declare module "mocha" {
  export interface Context {
    contracts: Contracts;
    mocks: Mocks;
    signers: Signers;
  }
}
