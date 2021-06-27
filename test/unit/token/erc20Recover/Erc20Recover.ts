import { erc20RecoverFixture } from "../../../shared/fixtures";
import { shouldBehaveLikeErc20Recover } from "./Erc20Recover.behavior";

export function testErc20Recover(): void {
  describe("Erc20Recover", function () {
    beforeEach(async function () {
      const { erc20Recover, mainToken, thirdPartyToken } = await this.loadFixture(erc20RecoverFixture);
      this.contracts.erc20Recover = erc20Recover;
      this.mocks.mainToken = mainToken;
      this.mocks.thirdPartyToken = thirdPartyToken;
    });

    shouldBehaveLikeErc20Recover();
  });
}
