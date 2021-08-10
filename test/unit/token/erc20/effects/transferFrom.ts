import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20Approve(): void {
  const transferAmount: BigNumber = token("100");

  context("when the token owner is the zero address", function () {
    const tokenOwner = AddressZero;
    it("reverts", async function () {
      const sender = this.signers.alice;
      const recipient = this.signers.bob;
      await expect(
        this.contracts.erc20.connect(sender).transferFrom(tokenOwner, recipient.address, transferAmount),
      ).to.be.revertedWith(Erc20Errors.TransferSenderZeroAddress);
    });
  });

  context("when the recipient is the zero address", function () {
    const recipient = AddressZero;
    beforeEach(async function () {
      await this.contracts.erc20.connect(this.signers.carol).approve(this.signers.alice.address, transferAmount);
    });

    it("reverts", async function () {
      const spender = this.signers.alice;
      const tokenOwner = this.signers.carol;
      await expect(
        this.contracts.erc20.connect(spender).transferFrom(tokenOwner.address, recipient, transferAmount),
      ).to.be.revertedWith(Erc20Errors.TransferRecipientZeroAddress);
    });
  });

  context("when the recipient is not the zero address", function () {
    context("when the spender does not have enough approved balance", function () {
      beforeEach(async function () {
        await this.contracts.erc20
          .connect(this.signers.carol)
          .approve(this.signers.alice.address, transferAmount.sub(1));
      });

      context("when the token owner does not have enough balance", function () {
        const newTransferAmount = transferAmount.add(1);
        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.carol).mint(this.signers.carol.address, transferAmount);
        });

        it("reverts", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .transferFrom(this.signers.carol.address, this.signers.bob.address, newTransferAmount),
          ).to.be.revertedWith(Erc20Errors.TransferUnderflow);
        });
      });

      context("when the token owner has enough balance", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .transferFrom(this.signers.carol.address, this.signers.bob.address, transferAmount),
          ).to.be.revertedWith(Erc20Errors.TransferUnderflow);
        });
      });
    });
    context("when the spender has enough approved balance", function () {
      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.carol).approve(this.signers.alice.address, transferAmount);
      });

      context("when the token owner does not have enough balance", function () {
        const newTransferAmount = transferAmount.add(1);

        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.carol).mint(this.signers.carol.address, transferAmount);
        });

        it("reverts", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .transferFrom(this.signers.carol.address, this.signers.bob.address, newTransferAmount),
          ).to.be.revertedWith(Erc20Errors.TransferUnderflow);
        });
      });

      context("when the token owner has enough balance", function () {
        beforeEach(async function () {
          await this.contracts.erc20.connect(this.signers.carol).mint(this.signers.carol.address, transferAmount);
        });

        it("transfers the requested amount", async function () {
          const tokenOwnerOldBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.carol.address);
          const recipientOldBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.bob.address);

          await this.contracts.erc20
            .connect(this.signers.alice)
            .transferFrom(this.signers.carol.address, this.signers.bob.address, transferAmount);

          const tokenOwnerNewBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.carol.address);
          const recipientNewBalance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.bob.address);

          expect(tokenOwnerNewBalance).to.equal(tokenOwnerOldBalance.sub(transferAmount));
          expect(recipientNewBalance).to.equal(recipientOldBalance.add(transferAmount));
        });

        it("decreases the spender allowance", async function () {
          const oldAllowanceAmount: BigNumber = await this.contracts.erc20
            .connect(this.signers.alice)
            .allowance(this.signers.carol.address, this.signers.alice.address);
          await this.contracts.erc20
            .connect(this.signers.alice)
            .transferFrom(this.signers.carol.address, this.signers.bob.address, transferAmount);
          const newAllowanceAmount: BigNumber = await this.contracts.erc20
            .connect(this.signers.alice)
            .allowance(this.signers.carol.address, this.signers.alice.address);
          expect(newAllowanceAmount).to.be.equal(oldAllowanceAmount.sub(transferAmount));
        });

        it("emits a transfer event", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .transferFrom(this.signers.carol.address, this.signers.bob.address, transferAmount),
          )
            .to.emit(this.contracts.erc20, "Transfer")
            .withArgs(this.signers.carol.address, this.signers.bob.address, transferAmount);
        });

        it("emits a approval event", async function () {
          await expect(
            this.contracts.erc20
              .connect(this.signers.alice)
              .transferFrom(this.signers.carol.address, this.signers.bob.address, transferAmount),
          )
            .to.emit(this.contracts.erc20, "Approval")
            .withArgs(this.signers.carol.address, this.signers.alice.address, transferAmount);
        });
      });
    });
  });
}
