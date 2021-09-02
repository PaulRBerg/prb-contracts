import { BigNumber } from "@ethersproject/bignumber";
import { AddressZero, Zero } from "@ethersproject/constants";
import { expect } from "chai";

import { Erc20Errors } from "../../../../shared/errors";
import { token } from "../../../../../helpers/numbers";

export default function shouldBehaveLikeERC20Mint(): void {
  const mintAmount: BigNumber = token("100");
  context("when the beneficiary is zero address", function () {
    it("reverts", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).mint(AddressZero, mintAmount)).to.be.revertedWith(
        Erc20Errors.MintZeroAddress,
      );
    });
  });

  context("when the beneficiary is a non-zero account", function () {
    it("increments totalSupply", async function () {
      const initialSupply = await this.contracts.erc20.totalSupply();
      await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount);
      const totalSupply = await this.contracts.erc20.totalSupply();
      expect(initialSupply).to.equal(totalSupply.sub(mintAmount));
    });

    it("increments beneficiary balance", async function () {
      await this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount);
      expect(await this.contracts.erc20.balanceOf(this.signers.alice.address)).to.equal(mintAmount);
    });

    it("emits a transfer event", async function () {
      await expect(this.contracts.erc20.connect(this.signers.alice).mint(this.signers.alice.address, mintAmount))
        .to.emit(this.contracts.erc20, "Transfer")
        .withArgs(AddressZero, this.signers.alice.address, mintAmount);
    });
  });
}
