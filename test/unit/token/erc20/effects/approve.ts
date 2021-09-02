import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";

import { Erc20Errors } from "../../../../shared/errors";

export default function shouldBehaveLikeApprove(): void {
  const amount: BigNumber = fp("100");
  const newAmount: BigNumber = fp("10");

  context("when the spender is the zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).approve(AddressZero, amount)).to.be.revertedWith(
        Erc20Errors.ApproveSpenderZeroAddress,
      );
    });
  });

  context("when the spender is not the zero address", function () {
    context("when the allowance is zero", function () {
      it("makes the approval", async function () {
        await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount);
        const allowance: BigNumber = await this.contracts.erc20.allowance(
          this.signers.alice.address,
          this.signers.bob.address,
        );
        expect(allowance).to.equal(amount);
      });
    });

    context("when the allowance is not zero", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount);
      });

      it("makes the approval", async function () {
        await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, newAmount);
        const allowance: BigNumber = await this.contracts.erc20.allowance(
          this.signers.alice.address,
          this.signers.bob.address,
        );
        expect(allowance).to.equal(newAmount);
      });

      it("emits an Approval event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount))
          .to.emit(this.contracts.erc20, "Approval")
          .withArgs(this.signers.alice.address, this.signers.bob.address, amount);
      });
    });
  });
}
