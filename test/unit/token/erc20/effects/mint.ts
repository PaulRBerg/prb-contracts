import type { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, MaxUint256, Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";

import { bn } from "../../../../../helpers/numbers";
import { Erc20Errors, PanicCodes } from "../../../../shared/errors";

export default function shouldBehaveLikeMint(): void {
  context("when the beneficiary is the zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).mint(AddressZero, Zero)).to.be.revertedWith(
        Erc20Errors.MintZeroAddress,
      );
    });
  });

  context("when the beneficiary is not the zero address", function () {
    context("when the mint results into an overflow", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, bn("1"));
      });

      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, MaxUint256),
        ).to.be.revertedWith(PanicCodes.ArithmeticOverflowOrUnderflow);
      });
    });

    context("when the mint does not result into an overflow", function () {
      const mintAmount: BigNumber = fp("100");

      it("increases the balance of the beneficiary", async function () {
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount);
        expect(await this.contracts.erc20.balanceOf(this.signers.alice.address)).to.equal(mintAmount);
      });

      it("increases the total supply", async function () {
        const preTotalSupply: BigNumber = await this.contracts.erc20.totalSupply();
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount);
        const postTotalSupply = await this.contracts.erc20.totalSupply();
        expect(preTotalSupply).to.equal(postTotalSupply.sub(mintAmount));
      });

      it("emits a Transfer event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount))
          .to.emit(this.contracts.erc20, "Transfer")
          .withArgs(AddressZero, this.signers.alice.address, mintAmount);
      });
    });
  });
}
