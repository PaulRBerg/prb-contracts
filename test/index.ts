import { Signer } from "@ethersproject/abstract-signer";
import { Wallet } from "@ethersproject/wallet";
import { ethers, waffle } from "@nomiclabs/buidler";

import { Accounts, Contracts, Signers, Stubs } from "../@types/index";
import { testErc20Permit } from "./token/erc20Permit/Erc20Permit";
import { testErc20Recover } from "./token/erc20Recover/Erc20Recover";

const { createFixtureLoader } = waffle;

describe("Unit Tests", function () {
  before(async function () {
    this.accounts = {} as Accounts;
    this.contracts = {} as Contracts;
    this.signers = {} as Signers;
    this.stubs = {} as Stubs;

    const signers: Signer[] = await ethers.getSigners();
    /* Get rid of this when https://github.com/nomiclabs/buidler/issues/849 gets fixed. */
    this.loadFixture = createFixtureLoader(signers as Wallet[]);

    this.signers.alice = signers[0];
    this.signers.bob = signers[1];
    this.signers.carol = signers[2];
    this.signers.david = signers[3];
    this.signers.eve = signers[4];

    this.accounts.alice = await signers[0].getAddress();
    this.accounts.bob = await signers[1].getAddress();
    this.accounts.carol = await signers[2].getAddress();
    this.accounts.david = await signers[3].getAddress();
    this.accounts.eve = await signers[4].getAddress();
  });

  testErc20Permit();
  testErc20Recover();
});
