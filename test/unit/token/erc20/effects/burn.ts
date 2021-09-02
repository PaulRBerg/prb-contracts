import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20Burn(): void {
  const burnAmount: BigNumber = token("10");
  context("when the holder is zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).burn(AddressZero, burnAmount)).to.be.revertedWith(
        Erc20Errors.BurnZeroAddress,
      );
    });
  });

  context("when the holder is a non-zero account", function () {
    describe("when holder balance is less than burn amount", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount),
        ).to.be.revertedWith(Erc20Errors.BurnUnderflow);
      });
    });
    describe("when holder balance is more than burn amount", function () {
      beforeEach(async function () {
        const mintAmount: BigNumber = token("100");
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount);
      });

      it("decrements holder initial balance", async function () {
        const initialBalanceOfHolder = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        await this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount);
        const balanceOfHolder = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        expect(balanceOfHolder).to.equal(initialBalanceOfHolder.sub(burnAmount));
      });

      it("decrements totalSupply", async function () {
        const initialSupply = await this.contracts.erc20.totalSupply();
        await this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount);
        const totalSupply = await this.contracts.erc20.totalSupply();
        expect(totalSupply).to.equal(initialSupply.sub(burnAmount));
      });

      it("emits a transfer event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount))
          .to.emit(this.contracts.erc20, "Transfer")
          .withArgs(this.signers.alice.address, AddressZero, burnAmount);
      });
    });
  });
}
