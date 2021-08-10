import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20BalanceOf(): void {
  context("balanceOf", function () {
    const initialBalance: BigNumber = token("100");

    context("when the requested account has no tokens", function () {
      it("returns zero", async function () {
        expect(await this.contracts.erc20.balanceOf(this.signers.alice.address)).to.be.equal("0");
      });
    });

    context("when the requested account has some tokens", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, initialBalance);
      });

      it("returns the total amount of tokens", async function () {
        expect(await this.contracts.erc20.balanceOf(this.signers.alice.address)).to.be.equal(initialBalance);
      });
    });
  });
}
