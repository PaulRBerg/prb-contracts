import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { AdminErrors, Erc20RecoverErrors, GenericErrors } from "../../../../helpers/errors";
import { OneHundredTokens } from "../../../../helpers/constants";

export default function shouldBehaveLikeRecover(): void {
  const recoverAmount: BigNumber = OneHundredTokens;

  describe("when the caller is the administrator", function () {
    describe("when the contract was initialized", function () {
      beforeEach(async function () {
        const mainTokenAddress: string = this.stubs.mainToken.address;
        await this.contracts.erc20Recover.setNonRecoverableTokens([mainTokenAddress]);
      });

      describe("when the amount to recover is not zero", function () {
        describe("when the token is recoverable", function () {
          beforeEach(async function () {
            await this.stubs.thirdPartyToken.mock.transfer.withArgs(this.accounts.alice, recoverAmount).returns(true);
          });

          it("recovers the tokens", async function () {
            await this.contracts.erc20Recover
              .connect(this.signers.alice)
              .recover(this.stubs.thirdPartyToken.address, recoverAmount);
          });

          it("emits a Recover event", async function () {
            await expect(
              this.contracts.erc20Recover
                .connect(this.signers.alice)
                .recover(this.stubs.thirdPartyToken.address, recoverAmount),
            )
              .to.emit(this.contracts.erc20Recover, "Recover")
              .withArgs(this.accounts.alice, this.stubs.thirdPartyToken.address, recoverAmount);
          });
        });

        describe("when the token is non-recoverable", function () {
          describe("when the token is part of the non-recoverable array", function () {
            it("reverts", async function () {
              await expect(
                this.contracts.erc20Recover
                  .connect(this.signers.alice)
                  .recover(this.stubs.mainToken.address, recoverAmount),
              ).to.be.revertedWith(Erc20RecoverErrors.RecoverNonRecoverableToken);
            });
          });

          describe("when the token is not part of the non-recoverable array but has the same symbol", function () {
            beforeEach(async function () {
              const collateralSymbol: string = await this.stubs.mainToken.symbol();
              await this.stubs.thirdPartyToken.mock.symbol.returns(collateralSymbol);
            });

            it("reverts", async function () {
              await expect(
                this.contracts.erc20Recover
                  .connect(this.signers.alice)
                  .recover(this.stubs.thirdPartyToken.address, recoverAmount),
              ).to.be.revertedWith(Erc20RecoverErrors.RecoverNonRecoverableToken);
            });
          });
        });
      });

      describe("when the amount to recover is zero", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20Recover.connect(this.signers.alice).recover(this.stubs.thirdPartyToken.address, Zero),
          ).to.be.revertedWith(Erc20RecoverErrors.RecoverZero);
        });
      });
    });

    describe("when the contract was not initialized", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20Recover
            .connect(this.signers.alice)
            .recover(this.stubs.thirdPartyToken.address, recoverAmount),
        ).to.be.revertedWith(GenericErrors.NotInitialized);
      });
    });
  });

  describe("when the caller is not the administrator", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20Recover
          .connect(this.signers.eve)
          .recover(this.stubs.thirdPartyToken.address, recoverAmount),
      ).to.be.revertedWith(AdminErrors.NotAdmin);
    });
  });
}
