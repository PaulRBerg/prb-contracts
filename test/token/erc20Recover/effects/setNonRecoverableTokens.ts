import { expect } from "chai";
import { AddressZero } from "@ethersproject/constants";

import { AdminErrors, GenericErrors } from "../../../../helpers/errors";

export default function shouldBehaveLikeSetNonRecoverableTokens(): void {
  describe("when the caller is the administrator", function () {
    describe("when the contract was not initialized", function () {
      describe("when the tokens are compliant", function () {
        it("sets the non-recoverable tokens", async function () {
          const mainTokenAddress: string = this.stubs.mainToken.address;
          await this.contracts.erc20Recover.connect(this.signers.alice)._setNonRecoverableTokens([mainTokenAddress]);
          const firstNonRecoverableTokens = await this.contracts.erc20Recover.nonRecoverableTokens(0);
          expect(firstNonRecoverableTokens).to.equal(mainTokenAddress);
        });

        it("initializes the contract", async function () {
          const mainTokenAddress: string = this.stubs.mainToken.address;
          const oldIsInitialized: boolean = await this.contracts.erc20Recover.__godMode_getIsRecoverInitialized();
          await this.contracts.erc20Recover.connect(this.signers.alice)._setNonRecoverableTokens([mainTokenAddress]);
          const newIsInitialized: boolean = await this.contracts.erc20Recover.__godMode_getIsRecoverInitialized();
          expect(oldIsInitialized).to.equal(false);
          expect(newIsInitialized).to.equal(true);
        });

        it("emits a SetNonRecoverableTokens event", async function () {
          const mainTokenAddress: string = this.stubs.mainToken.address;
          await expect(
            this.contracts.erc20Recover.connect(this.signers.alice)._setNonRecoverableTokens([mainTokenAddress]),
          )
            .to.emit(this.contracts.erc20Recover, "SetNonRecoverableTokens")
            .withArgs(this.accounts.alice, [mainTokenAddress]);
        });
      });

      describe("when the tokens are non-compliant", function () {
        it("reverts", async function () {
          await expect(this.contracts.erc20Recover._setNonRecoverableTokens([AddressZero])).to.be.reverted;
        });
      });
    });

    describe("when the contract was initialized", function () {
      beforeEach(async function () {
        await this.contracts.erc20Recover.__godMode_setIsRecoverInitialized(true);
      });

      it("reverts", async function () {
        await expect(
          this.contracts.erc20Recover.connect(this.signers.alice)._setNonRecoverableTokens([AddressZero]),
        ).to.be.revertedWith(GenericErrors.Initialized);
      });
    });
  });

  describe("when the caller is not the administrator", function () {
    it("reverts", async function () {
      await expect(
        this.contracts.erc20Recover.connect(this.signers.eve)._setNonRecoverableTokens([AddressZero]),
      ).to.be.revertedWith(AdminErrors.NotAdmin);
    });
  });
}
