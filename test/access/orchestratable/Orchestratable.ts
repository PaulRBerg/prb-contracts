import { orchestratableFixture } from "../../fixtures";
import { shouldBehaveLikeOrchestratable } from "./Orchestratable.behavior";

export function testErc20Recover(): void {
  describe("Orchestratable", function () {
    beforeEach(async function () {
      const { erc20Recover, mainToken, thirdPartyToken } = await this.loadFixture(orchestratableFixture);
      this.contracts.erc20Recover = erc20Recover;
      this.stubs.mainToken = mainToken;
      this.stubs.thirdPartyToken = thirdPartyToken;
    });

    shouldBehaveLikeOrchestratable();
  });
}
