import { expect } from "chai";
import { AddressZero } from "@ethersproject/constants";

import { AdminErrors, Erc20RecoverErrors, GenericErrors } from "../../../../utils/errors";

export default function shouldBehaveLikeSetNonRecoverableTokens(): void {
  describe("when the caller is the administrator", function () {
    describe("when the contract was not initialized", function () {
      describe("when the token array is non-empty", function () {
        describe("when the tokens are compliant", function () {
          it("sets the non-recoverable tokens", async function () {
            const mainTokenAddress: string = this.stubs.mainToken.address;
            await this.contracts.erc20Recover.connect(this.signers.alice).setNonRecoverableTokens([mainTokenAddress]);
            const firstNonRecoverableTokens = await this.contracts.erc20Recover.nonRecoverableTokens(0);
            expect(firstNonRecoverableTokens).to.equal(mainTokenAddress);
          });

          it("initializes the contract", async function () {
            const mainTokenAddress: string = this.stubs.mainToken.address;
            const oldIsInitialized: boolean = await this.contracts.erc20Recover.isInitialized();
            await this.contracts.erc20Recover.connect(this.signers.alice).setNonRecoverableTokens([mainTokenAddress]);
            const newIsInitialized: boolean = await this.contracts.erc20Recover.isInitialized();
            expect(oldIsInitialized).to.equal(false);
            expect(newIsInitialized).to.equal(true);
          });

          it("emits a SetNonRecoverableTokens event", async function () {
            const mainTokenAddress: string = this.stubs.mainToken.address;
            await expect(
              this.contracts.erc20Recover.connect(this.signers.alice).setNonRecoverableTokens([mainTokenAddress]),
            )
              .to.emit(this.contracts.erc20Recover, "SetNonRecoverableTokens")
              .withArgs(this.accounts.alice, [mainTokenAddress]);
          });
        });

        describe("when the tokens are non-compliant", function () {
          it("reverts", async function () {
            await expect(this.contracts.erc20Recover.setNonRecoverableTokens([AddressZero])).to.be.reverted;
          });
        });
      });

      describe("when the token array is empty", function () {
        it("reverts", async function () {
          await expect(
            this.contracts.erc20Recover.connect(this.signers.alice).setNonRecoverableTokens([]),
          ).to.be.revertedWith(Erc20RecoverErrors.SetNonRecoverableTokensEmptyArray);
        });
      });
    });

    describe("when the contract was initialized", function () {
      beforeEach(async function () {
        await this.contracts.erc20Recover.__godMode_setIsInitialized(true);
      });

      it("reverts", async function () {
        await expect(
          this.contracts.erc20Recover.connect(this.signers.alice).setNonRecoverableTokens([AddressZero]),
        ).to.be.revertedWith(GenericErrors.Initialized);
      });
    });
  });

  describe("when the caller is not the administrator", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20Recover.connect(this.signers.eve).setNonRecoverableTokens([AddressZero]),
      ).to.be.revertedWith(AdminErrors.NotAdmin);
    });
  });
}
