import type { BigNumber } from "@ethersproject/bignumber";
import { AddressZero } from "@ethersproject/constants";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { toBn } from "evm-bn";

import { Erc20Errors } from "../../../../shared/errors";

export default function shouldBehaveLikeTransfer(): void {
  const transferAmount: BigNumber = toBn("100");
  let recipient: SignerWithAddress;
  let sender: SignerWithAddress;

  beforeEach(async function () {
    recipient = this.signers.bob;
    sender = this.signers.alice;
  });

  context("when the sender is the zero address", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20.connect(AddressZero).transfer(recipient.address, transferAmount),
      ).to.be.revertedWith(Erc20Errors.TransferSenderZeroAddress);
    });
  });

  context("when the sender is not the zero address", function () {
    context("when the recipient is the zero address", function () {
      it("reverts", async function () {
        await expect(this.contracts.erc20.connect(sender).transfer(AddressZero, transferAmount)).to.be.revertedWith(
          Erc20Errors.TransferRecipientZeroAddress,
        );
      });
    });

    context("when the recipient is not the zero address", function () {
      context("when the sender does not have enough balance", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20.connect(sender).transfer(recipient.address, transferAmount),
          ).to.be.revertedWith(Erc20Errors.InsufficientBalance);
        });
      });

      context("when the sender has enough balance", function () {
        beforeEach(async function () {
          await this.contracts.erc20.connect(sender).mint(sender.address, transferAmount);
        });

        it("makes the transfer", async function () {
          const senderPreBalance: BigNumber = await this.contracts.erc20.balanceOf(sender.address);
          const recipientPreBalance: BigNumber = await this.contracts.erc20.balanceOf(recipient.address);
          await this.contracts.erc20.connect(sender).transfer(recipient.address, transferAmount);
          const senderPostBalance: BigNumber = await this.contracts.erc20.balanceOf(sender.address);
          const recipientPostBalance: BigNumber = await this.contracts.erc20.balanceOf(recipient.address);
          expect(senderPostBalance).to.equal(senderPreBalance.sub(transferAmount));
          expect(recipientPostBalance).to.equal(recipientPreBalance.add(transferAmount));
        });

        it("emits a Transfer event", async function () {
          await expect(this.contracts.erc20.connect(sender).transfer(recipient.address, transferAmount))
            .to.emit(this.contracts.erc20, "Transfer")
            .withArgs(sender.address, recipient.address, transferAmount);
        });
      });
    });
  });
}
