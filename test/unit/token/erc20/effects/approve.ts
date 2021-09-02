import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20Approve(): void {
  const amount: BigNumber = token("100");
  const newAmount: BigNumber = token("10");

  context("when the spender is the zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).approve(AddressZero, amount)).to.be.revertedWith(
        Erc20Errors.ApproveSpenderZeroAddress,
      );
    });
  });

  context("when the spender is not the zero address", function () {
    context("when the sender does not have enough balance", function () {
      const largeAmount = amount.add(1);
      context("when there was no approved amount before", function () {
        it("approves the requested amount", async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, largeAmount);
          const allowanceAmount: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          expect(allowanceAmount).to.equal(largeAmount);
        });
      });

      context("when the spender had an approved amount", function () {
        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount);
        });

        it("approves the requested amount and replaces the previous one", async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, largeAmount);
          const allowanceAmount: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          expect(allowanceAmount).to.equal(largeAmount);
        });
      });

      it("emits an approval event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, largeAmount))
          .to.emit(this.contracts.erc20, "Approval")
          .withArgs(this.signers.alice.address, this.signers.bob.address, largeAmount);
      });
    });

    context("when the sender has enough balance", function () {
      context("when there was no approved amount before", function () {
        it("approves the requested amount", async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount);
          const allowanceAmount: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          expect(allowanceAmount).to.equal(amount);
        });
      });

      context("when the spender had an approved amount", function () {
        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount);
        });

        it("approves the requested amount and replaces the previous one", async function () {
          await this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, newAmount);
          const allowanceAmount: BigNumber = await this.contracts.erc20.allowance(
            this.signers.alice.address,
            this.signers.bob.address,
          );
          expect(allowanceAmount).to.equal(newAmount);
        });
      });

      it("emits an approval event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).approve(this.signers.bob.address, amount))
          .to.emit(this.contracts.erc20, "Approval")
          .withArgs(this.signers.alice.address, this.signers.bob.address, amount);
      });
    });
  });
}
