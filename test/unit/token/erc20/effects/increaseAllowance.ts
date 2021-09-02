import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, MaxUint256 } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";

import { bn } from "../../../../../helpers/numbers";
import { Erc20Errors, PanicCodes } from "../../../../shared/errors";

export default function shouldBehaveLikeIncreaseAllowance(): void {
  const addedAmount: BigNumber = fp("100");

  context("when the spender is the zero address", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20.connect(this.signers.alice).increaseAllowance(AddressZero, addedAmount),
      ).to.be.revertedWith(Erc20Errors.ApproveSpenderZeroAddress);
    });
  });

  context("when the spender is not the zero address", function () {
    context("when the increase allowance results into an underflow", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, bn("1"));
      });

      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).increaseAllowance(this.signers.bob.address, MaxUint256),
        ).to.be.revertedWith(PanicCodes.ArithmeticOverflowOrUnderflow);
      });
    });

    context("when the increase allowance does not result into an underflow", function () {
      it("increases the allowance", async function () {
        const preAllowance: BigNumber = await this.contracts.erc20.allowance(
          this.signers.alice.address,
          this.signers.bob.address,
        );
        await this.contracts.erc20.connect(this.signers.alice).increaseAllowance(this.signers.bob.address, addedAmount);
        const postAllowance: BigNumber = await this.contracts.erc20.allowance(
          this.signers.alice.address,
          this.signers.bob.address,
        );
        expect(preAllowance).to.equal(postAllowance.sub(addedAmount));
      });

      it("emits an Approval event", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).increaseAllowance(this.signers.bob.address, addedAmount),
        )
          .to.emit(this.contracts.erc20, "Approval")
          .withArgs(this.signers.alice.address, this.signers.bob.address, addedAmount);
      });
    });
  });
}
