import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";

export default function shouldBehaveLikeERC20BalanceOf(): void {
  context("balanceOf", function () {
    context("when the account does not have a balance", function () {
      it("retrieves zero", async function () {
        const balance: BigNumber = await this.contracts.erc20.balanceOf(this.signers.alice.address);
        expect(balance).to.equal(Zero);
      });
    });

    context("when the account has a balance", function () {
      const initialBalance: BigNumber = fp("100");

      beforeEach(async function () {
        await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, initialBalance);
      });

      it("retrieves the correct balance", async function () {
        expect(await this.contracts.erc20.balanceOf(this.signers.alice.address)).to.be.equal(initialBalance);
      });
    });
  });
}
