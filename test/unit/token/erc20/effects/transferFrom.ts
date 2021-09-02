import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import fp from "evm-fp";

import { Erc20Errors } from "../../../../shared/errors";

export default function shouldBehaveLikeTransferFrom(): void {
  const transferAmount: BigNumber = fp("100");
  let owner: SignerWithAddress;
  let recipient: SignerWithAddress;
  let spender: SignerWithAddress;

  beforeEach(async function () {
    owner = this.signers.bob;
    recipient = this.signers.carol;
    spender = this.signers.alice;
  });

  context("when the owner is the zero address", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20.connect(spender).transferFrom(AddressZero, recipient.address, transferAmount),
      ).to.be.revertedWith(Erc20Errors.TransferSenderZeroAddress);
    });
  });

  context("when the owner is not the zero address", function () {
    context("when the recipient is the zero address", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(owner).approve(spender.address, transferAmount);
      });

      it("reverts", async function () {
        await expect(
          this.contracts.erc20.connect(spender).transferFrom(owner.address, AddressZero, transferAmount),
        ).to.be.revertedWith(Erc20Errors.TransferRecipientZeroAddress);
      });
    });

    context("when the recipient is not the zero address", function () {
      context("when the owner does not have enough balance", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20.connect(spender).transferFrom(owner.address, recipient.address, transferAmount),
          ).to.be.revertedWith(Erc20Errors.InsufficientBalance);
        });
      });

      context("when the owner has enough balance", function () {
        beforeEach(async function () {
          await this.contracts.erc20.mint(owner.address, transferAmount);
        });

        context("when the spender does not have enough allowance", function () {
          it("reverts", async function () {
            await expect(
              this.contracts.erc20.connect(spender).transferFrom(owner.address, recipient.address, transferAmount),
            ).to.be.revertedWith(Erc20Errors.InsufficientAllowance);
          });
        });

        context("when the spender has enough allowance", function () {
          beforeEach(async function () {
            await this.contracts.erc20.connect(owner).approve(spender.address, transferAmount);
          });

          it("emits a Transfer event", async function () {
            await expect(
              this.contracts.erc20.connect(spender).transferFrom(owner.address, recipient.address, transferAmount),
            )
              .to.emit(this.contracts.erc20, "Transfer")
              .withArgs(owner.address, recipient.address, transferAmount);
          });

          it("emits an Approval event", async function () {
            await expect(
              this.contracts.erc20.connect(spender).transferFrom(owner.address, recipient.address, transferAmount),
            )
              .to.emit(this.contracts.erc20, "Approval")
              .withArgs(owner.address, spender.address, Zero);
          });
        });
      });
    });
  });
}
