import { expect } from "chai";

export default function shouldBehaveLikeIsRecoverInitialized(): void {
  describe("when the non-recoverable token array was not set", function () {
    it("retrieves false", async function () {
      const isRecoverInitialized: boolean = await this.contracts.erc20Recover.__godMode_getIsRecoverInitialized();
      expect(isRecoverInitialized).to.equal(false);
    });
  });
}
