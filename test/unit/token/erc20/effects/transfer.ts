import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20Approve(): void {
  const senderBalance: BigNumber = token("100");
  const amount: BigNumber = token("10");

  context("when the sender is the zero address", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20.connect(AddressZero).transfer(this.signers.bob.address, amount),
      ).to.be.revertedWith(Erc20Errors.TransferSenderZeroAddress);
    });
  });

  context("when the recipient is the zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).transfer(AddressZero, amount)).to.be.revertedWith(
        Erc20Errors.TransferRecipientZeroAddress,
      );
    });
  });

  context("when the recipient is not the zero address", function () {
    context("when the sender does not have enough balance", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(this.signers.alice).transfer(this.signers.bob.address, amount),
        ).to.be.revertedWith(Erc20Errors.TransferUnderflow);
      });
    });

    context("when the sender transfers requested amount", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, senderBalance);
      });

      it("transfers the requested amount", async function () {
        const senderOldBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        const recipientOldBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.bob.address);
        await this.contracts.erc20.connect(this.signers.alice).transfer(this.signers.bob.address, amount);
        const senderNewBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        const recipientNewBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.bob.address);
        expect(senderNewBalance).to.equal(senderOldBalance.sub(amount));
        expect(recipientNewBalance).to.equal(recipientOldBalance.add(amount));
      });

      it("emits a transfer event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).transfer(this.signers.bob.address, amount))
          .to.emit(this.contracts.erc20, "Transfer")
          .withArgs(this.signers.alice.address, this.signers.bob.address, amount);
      });
    });

    context("when the sender transfers zero tokens", function () {
      const zeroAmount: BigNumber = Zero;
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, senderBalance);
      });

      it("transfers the zero amount", async function () {
        const senderOldBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        await this.contracts.erc20.connect(this.signers.alice).transfer(this.signers.bob.address, zeroAmount);
        const senderNewBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        expect(senderNewBalance).to.equal(senderOldBalance);
      });

      it("emits a transfer event", async function () {
        await expect(this.contracts.erc20.connect(this.signers.alice).transfer(this.signers.bob.address, zeroAmount))
          .to.emit(this.contracts.erc20, "Transfer")
          .withArgs(this.signers.alice.address, this.signers.bob.address, zeroAmount);
      });
    });
  });
}
