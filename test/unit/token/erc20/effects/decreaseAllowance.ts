import type { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";

import { ERC20Errors, PanicCodes } from "../../../../shared/errors";

export default function shouldBehaveLikeDecreaseAllowance(): void {
  const subtractedAmount: BigNumber = toBn("100");

  context("when the spender is the zero address", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20.connect(this.signers.alice).decreaseAllowance(AddressZero, Zero),
      ).to.be.revertedWith(ERC20Errors.ApproveSpenderZeroAddress);
    });
  });

  context("when the spender is not the zero address", function () {
    context("when the decrease allowance results into an underflow", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20
            .connect(this.signers.alice)
            .decreaseAllowance(this.signers.bob.address, subtractedAmount),
        ).to.be.revertedWith(PanicCodes.ArithmeticOverflowOrUnderflow);
      });
    });

    context("when the decrease allowance does not result into an underflow", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, subtractedAmount);
      });

      context("when a part of the allowance is decreased", function () {
        const partialSubtractedValue: BigNumber = toBn("10");

        it("decreases the allowance", async function () {
          const preAllowance: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          await this.contracts.erc20
            .connect(this.signers.alice)
            .decreaseAllowance(this.signers.bob.address, partialSubtractedValue);
          const postAllowance: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          expect(preAllowance).to.equal(postAllowance.add(partialSubtractedValue));
        });
      });

      context("when the entire allowance is decreased", function () {
        it("decreases the allowance", async function () {
          const preAllowance: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          await this.contracts.erc20
            .connect(this.signers.alice)
            .decreaseAllowance(this.signers.bob.address, subtractedAmount);
          const postAllowance: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          expect(preAllowance).to.equal(postAllowance.add(subtractedAmount));
        });

        it("emits an Approval event", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .decreaseAllowance(this.signers.bob.address, subtractedAmount),
          )
            .to.emit(this.contracts.erc20, "Approval")
            .withArgs(this.signers.alice.address, this.signers.bob.address, Zero);
        });
      });
    });
  });
}
