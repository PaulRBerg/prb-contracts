import { Signer } from "@ethersproject/abstract-signer";
import { Wallet } from "@ethersproject/wallet";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { ethers, waffle } from "hardhat";

import { Contracts, Signers, Stubs } from "../types/index";

const { createFixtureLoader } = waffle;

export function baseContext(description: string, hooks: () => void): void {
  describe(description, function () {
    before(async function () {
      this.contracts = {} as Contracts;
      this.signers = {} as Signers;
      this.stubs = {} as Stubs;

      const signers: SignerWithAddress[] = await ethers.getSigners();
      this.signers.alice = signers[0];
      this.signers.bob = signers[1];
      this.signers.carol = signers[2];
      this.signers.david = signers[3];
      this.signers.eve = signers[4];

      // Get rid of this when https://github.com/nomiclabs/hardhat/issues/849 gets fixed.
      this.loadFixture = createFixtureLoader((signers as Signer[]) as Wallet[]);
    });

    hooks();
  });
}
