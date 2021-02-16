import hre from "hardhat";
import { AddressZero } from "@ethersproject/constants";
import { BigNumber } from "@ethersproject/bignumber";
import { SigningKey } from "@ethersproject/signing-key";
import { Signature } from "@ethersproject/bytes";
import { expect } from "chai";

import { chainIds, defaultPrivateKeys } from "../../../../../helpers/constants";
import { Erc20PermitErrors } from "../../../../../helpers/errors";
import { getPermitDigest } from "../../../../../helpers/eip2612";

const allowanceAmount: BigNumber = BigNumber.from(100);
const dummySignature: { v: BigNumber; r: string; s: string } = {
  v: BigNumber.from(27),
  r: "0x0000000000000000000000000000000000000000000000000000000000000001",
  s: "0x0000000000000000000000000000000000000000000000000000000000000002",
};
// December 31, 1999 at 16:00 GMT
const december1999: BigNumber = BigNumber.from(946656000);
// December 31, 2099 at 16:00 GMT
const december2099: BigNumber = BigNumber.from(4102416000);

async function createSignature(
  this: Mocha.Context,
  deadline: BigNumber,
  owner: string,
  spender: string,
): Promise<Signature> {
  // Get the user's nonce.
  const nonce: BigNumber = BigNumber.from(await this.contracts.erc20Permit.nonces(this.signers.bob.address));

  // Create the approval request.
  const approve = {
    amount: allowanceAmount,
    owner,
    spender,
  };

  // Get the EIP712 digest.
  const digest: string = await getPermitDigest(
    this.contracts.erc20Permit,
    BigNumber.from(hre.network.config.chainId ? hre.network.config.chainId : chainIds.hardhat),
    approve,
    nonce,
    deadline,
  );

  // Sign the digest.
  const bobSigningKey = new SigningKey(defaultPrivateKeys.bob);
  const signature: Signature = bobSigningKey.signDigest(digest);

  return signature;
}

export default function shouldBehaveLikePermit(): void {
  describe("when the owner is not the zero address", function () {
    describe("when the spender is not the zero address", function () {
      describe("when the deadline is in the future", function () {
        const deadline: BigNumber = december2099;

        describe("when the recovered owner is not the zero address", function () {
          describe("when the signature is valid", function () {
            it("lets the spender claim the allowance signed by the owner", async function () {
              const owner: string = this.signers.bob.address;
              const spender: string = this.signers.alice.address;
              const signature = await createSignature.call(this, deadline, owner, spender);

              await this.contracts.erc20Permit
                .connect(this.signers.alice)
                .permit(owner, spender, allowanceAmount, deadline, signature.v, signature.r, signature.s);
              const allowance: BigNumber = await this.contracts.erc20Permit.allowance(owner, spender);
              expect(allowance).to.equal(allowanceAmount);
            });

            it("increases the nonce of the user", async function () {
              const owner: string = this.signers.bob.address;
              const spender: string = this.signers.alice.address;
              const signature = await createSignature.call(this, deadline, owner, spender);

              const oldNonce = await this.contracts.erc20Permit.nonces(owner);
              await this.contracts.erc20Permit
                .connect(this.signers.alice)
                .permit(owner, spender, allowanceAmount, deadline, signature.v, signature.r, signature.s);
              const newNonce = await this.contracts.erc20Permit.nonces(owner);
              expect(oldNonce).to.equal(newNonce.sub(1));
            });

            it("emits an Approval event", async function () {
              const owner: string = this.signers.bob.address;
              const spender: string = this.signers.alice.address;
              const signature = await createSignature.call(this, deadline, owner, spender);

              await expect(
                this.contracts.erc20Permit
                  .connect(this.signers.alice)
                  .permit(owner, spender, allowanceAmount, deadline, signature.v, signature.r, signature.s),
              )
                .to.emit(this.contracts.erc20Permit, "Approval")
                .withArgs(owner, spender, allowanceAmount);
            });
          });

          describe("when the signature is not valid", function () {
            it("reverts", async function () {
              const owner: string = this.signers.bob.address;
              const spender: string = this.signers.alice.address;
              await expect(
                this.contracts.erc20Permit
                  .connect(this.signers.alice)
                  .permit(
                    owner,
                    spender,
                    allowanceAmount,
                    deadline,
                    dummySignature.v,
                    dummySignature.r,
                    dummySignature.s,
                  ),
              ).to.be.revertedWith(Erc20PermitErrors.InvalidSignature);
            });
          });
        });

        describe("when the recovered owner is the zero address", function () {
          it("reverts", async function () {
            const owner: string = this.signers.bob.address;
            const spender: string = this.signers.alice.address;
            const signature = await createSignature.call(this, deadline, owner, spender);
            /**
             * Providing any number but 27 or 28 for the `v` argument of the ECDSA signature makes
             * the `ecrecover` precompile return the zero address.
             * https://ethereum.stackexchange.com/questions/69328/how-to-get-the-zero-address-from-ecrecover
             */
            const goofedV: BigNumber = BigNumber.from(10);
            await expect(
              this.contracts.erc20Permit
                .connect(this.signers.alice)
                .permit(owner, spender, allowanceAmount, deadline, goofedV, signature.r, signature.s),
            ).to.be.revertedWith(Erc20PermitErrors.RecoveredOwnerZeroAddress);
          });
        });
      });

      describe("when the deadline is in the past", function () {
        const deadline: BigNumber = december1999;

        it("reverts", async function () {
          const owner: string = this.signers.bob.address;
          const spender: string = this.signers.alice.address;
          const signature = await createSignature.call(this, deadline, owner, spender);
          await expect(
            this.contracts.erc20Permit
              .connect(this.signers.alice)
              .permit(owner, spender, allowanceAmount, deadline, signature.v, signature.r, signature.s),
          ).to.be.revertedWith(Erc20PermitErrors.Expired);
        });
      });
    });

    describe("when the spender is the zero address", function () {
      it("reverts", async function () {
        const owner: string = this.signers.bob.address;
        const spender: string = AddressZero;
        const deadline: BigNumber = december2099;
        await expect(
          this.contracts.erc20Permit
            .connect(this.signers.alice)
            .permit(owner, spender, allowanceAmount, deadline, dummySignature.v, dummySignature.r, dummySignature.s),
        ).to.be.revertedWith(Erc20PermitErrors.SpenderZeroAddress);
      });
    });
  });

  describe("when the owner is the zero address", function () {
    it("reverts", async function () {
      const owner: string = AddressZero;
      const spender: string = this.signers.alice.address;
      const deadline: BigNumber = december2099;
      await expect(
        this.contracts.erc20Permit
          .connect(this.signers.alice)
          .permit(owner, spender, allowanceAmount, deadline, dummySignature.v, dummySignature.r, dummySignature.s),
      ).to.be.revertedWith(Erc20PermitErrors.OwnerZeroAddress);
    });
  });
}
