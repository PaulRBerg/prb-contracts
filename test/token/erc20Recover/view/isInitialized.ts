import { expect } from "chai";

export default function shouldBehaveLikeIsInitialized(): void {
  describe("when the non-recoverable token array was not set", function () {
    it("retrieves false", async function () {
      const isInitialized: boolean = await this.contracts.erc20Recover.isInitialized();
      expect(isInitialized).to.equal(false);
    });
  });
}
