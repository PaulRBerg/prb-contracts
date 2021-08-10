import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20DecreaseAllowance(): void {
  context("decrease allowance", function () {
    const approvedAmount: BigNumber = token("100");

    context("when the spender is the zero address", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).decreaseAllowance(AddressZero, approvedAmount),
        ).to.be.revertedWith(Erc20Errors.DecreasedAllowanceBelowZero);
      });
    });

    context("when the spender is not the zero address", function () {
      context("when there was no approved amount before", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .decreaseAllowance(this.signers.bob.address, approvedAmount),
          ).to.be.revertedWith(Erc20Errors.DecreasedAllowanceBelowZero);
        });
      });
      context("when the spender had an approved amount", function () {
        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, approvedAmount);
        });

        it("reverts when more than the full allowance is removed", async function () {
          it("reverts", async function () {
            await expect(
              this.contracts.erc20
                .connect(this.signers.alice)
                .decreaseAllowance(this.signers.bob.address, approvedAmount),
            ).to.be.revertedWith(Erc20Errors.DecreasedAllowanceBelowZero);
          });
        });

        it("sets the allowance to zero when all allowance is removed", async function () {
          await this.contracts.erc20
            .connect(this.signers.alice)
            .decreaseAllowance(this.signers.bob.address, approvedAmount);
          expect(await this.contracts.erc20.allowance(this.signers.alice.address, this.signers.bob.address)).to.equal(
            "0",
          );
        });

        it("decreases the spender allowance subtracting the requested amount", async function () {
          await this.contracts.erc20
            .connect(this.signers.alice)
            .decreaseAllowance(this.signers.bob.address, approvedAmount.sub(1));
          expect(await this.contracts.erc20.allowance(this.signers.alice.address, this.signers.bob.address)).to.equal(
            "1",
          );
        });

        it("emits an approval event", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .decreaseAllowance(this.signers.bob.address, approvedAmount),
          )
            .to.emit(this.contracts.erc20, "Approval")
            .withArgs(this.signers.alice.address, this.signers.bob.address, Zero);
        });
      });
    });
  });
}
