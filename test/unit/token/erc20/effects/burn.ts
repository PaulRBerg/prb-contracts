import type { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";

import { Erc20Errors, PanicCodes } from "../../../../shared/errors";

export default function shouldBehaveLikeBurn(): void {
  context("when the holder is the zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).burn(AddressZero, Zero)).to.be.revertedWith(
        Erc20Errors.BurnZeroAddress,
      );
    });
  });

  context("when the holder is not the zero address", function () {
    const burnAmount: BigNumber = fp("10");

    context("when the burn results into an underflow", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount),
        ).to.be.revertedWith(PanicCodes.ArithmeticOverflowOrUnderflow);
      });
    });

    context("when the burn does not result into an underflow", function () {
      beforeEach(async function () {
        const mintAmount: BigNumber = fp("100");
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount);
      });

      it("decreases the balance of the holder", async function () {
        const preBalance = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        await this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount);
        const postBalance = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        expect(preBalance).to.equal(postBalance.add(burnAmount));
      });

      it("decreases the total supply", async function () {
        const preTotalSupply: BigNumber = await this.contracts.erc20.totalSupply();
        await this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount);
        const postTotalSupply: BigNumber = await this.contracts.erc20.totalSupply();
        expect(preTotalSupply).to.equal(postTotalSupply.add(burnAmount));
      });

      it("emits a Transfer event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).burn(this.signers.alice.address, burnAmount))
          .to.emit(this.contracts.erc20, "Transfer")
          .withArgs(this.signers.alice.address, AddressZero, burnAmount);
      });
    });
  });
}
