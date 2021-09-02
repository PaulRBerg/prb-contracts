import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20IncreaseAllowance(): void {
  context("increase allowance", function () {
    const approvedAmount: BigNumber = token("100");

    context("when the spender is the zero address", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).increaseAllowance(AddressZero, approvedAmount),
        ).to.be.revertedWith(Erc20Errors.ApproveSpenderZeroAddress);
      });
    });

    context("when the spender is not the zero address", function () {
      context("when there was no approved amount before", function () {
        it("increases the spender allowance by the requested amount", async function () {
          await this.contracts.erc20
            .connect(this.signers.alice)
            .increaseAllowance(this.signers.bob.address, approvedAmount);
          await expect(
            await this.contracts.erc20.allowance(this.signers.alice.address, this.signers.bob.address),
          ).to.equal(approvedAmount);
        });
      });

      context("when there was approved amount before", function () {
        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, approvedAmount);
        });

        it("increases the spender allowance adding the requested amount", async function () {
          const newApproveAmount: BigNumber = token("1");
          await this.contracts.erc20
            .connect(this.signers.alice)
            .increaseAllowance(this.signers.bob.address, newApproveAmount);
          await expect(
            await this.contracts.erc20.allowance(this.signers.alice.address, this.signers.bob.address),
          ).to.equal(approvedAmount.add(newApproveAmount));
        });
      });

      it("emits an approval event", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).increaseAllowance(this.signers.bob.address, approvedAmount),
        )
          .to.emit(this.contracts.erc20, "Approval")
          .withArgs(this.signers.alice.address, this.signers.bob.address, approvedAmount);
      });
    });
  });
}
