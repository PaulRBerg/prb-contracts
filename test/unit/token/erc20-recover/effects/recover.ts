import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";

import { Erc20RecoverErrors, GenericErrors, OwnableErrors } from "../../../../shared/errors";

export default function shouldBehaveLikeRecover(): void {
  const recoverAmount: BigNumber = toBn("100");

  describe("when the caller is the owner", function () {
    describe("when the contract was initialized", function () {
      beforeEach(async function () {
        const mainTokenAddress: string = this.mocks.mainToken.address;
        await this.contracts.erc20Recover._setNonRecoverableTokens([mainTokenAddress]);
      });

      describe("when the amount to recover is not zero", function () {
        describe("when the token is recoverable", function () {
          beforeEach(async function () {
            await this.mocks.thirdPartyToken.mock.transfer
              .withArgs(this.signers.alice.address, recoverAmount)
              .returns(true);
          });

          it("recovers the tokens", async function () {
            await this.contracts.erc20Recover
              .connect(this.signers.alice)
              ._recover(this.mocks.thirdPartyToken.address, recoverAmount);
          });

          it("emits a Recover event", async function () {
            await expect(
              this.contracts.erc20Recover
                .connect(this.signers.alice)
                ._recover(this.mocks.thirdPartyToken.address, recoverAmount),
            )
              .to.emit(this.contracts.erc20Recover, "Recover")
              .withArgs(this.signers.alice.address, this.mocks.thirdPartyToken.address, recoverAmount);
          });
        });

        describe("when the token is non-recoverable", function () {
          describe("when the token is part of the non-recoverable array", function () {
            it("reverts", async function () {
              await expect(
                this.contracts.erc20Recover
                  .connect(this.signers.alice)
                  ._recover(this.mocks.mainToken.address, recoverAmount),
              ).to.be.revertedWith(Erc20RecoverErrors.NonRecoverableToken);
            });
          });

          describe("when the token is not part of the non-recoverable array but has the same symbol", function () {
            beforeEach(async function () {
              const collateralSymbol: string = await this.mocks.mainToken.symbol();
              await this.mocks.thirdPartyToken.mock.symbol.returns(collateralSymbol);
            });

            it("reverts", async function () {
              await expect(
                this.contracts.erc20Recover
                  .connect(this.signers.alice)
                  ._recover(this.mocks.thirdPartyToken.address, recoverAmount),
              ).to.be.revertedWith(Erc20RecoverErrors.NonRecoverableToken);
            });
          });
        });
      });

      describe("when the amount to recover is zero", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20Recover.connect(this.signers.alice)._recover(this.mocks.thirdPartyToken.address, Zero),
          ).to.be.revertedWith(Erc20RecoverErrors.RecoverZero);
        });
      });
    });

    describe("when the contract was not initialized", function () {
      it("reverts", async function () {
        await expect(
          this.contracts.erc20Recover
            .connect(this.signers.alice)
            ._recover(this.mocks.thirdPartyToken.address, recoverAmount),
        ).to.be.revertedWith(GenericErrors.NotInitialized);
      });
    });
  });

  describe("when the caller is not the owner", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20Recover
          .connect(this.signers.eve)
          ._recover(this.mocks.thirdPartyToken.address, recoverAmount),
      ).to.be.revertedWith(OwnableErrors.NotOwner);
    });
  });
}
