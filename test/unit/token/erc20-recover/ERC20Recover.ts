import { erc20RecoverFixture } from "../../../shared/fixtures";
import { shouldBehaveLikeERC20Recover } from "./ERC20Recover.behavior";

export function testERC20Recover(): void {
  describe("ERC20Recover", function () {
    beforeEach(async function () {
      const { erc20Recover, mainToken, thirdPartyToken } = await this.loadFixture(erc20RecoverFixture);
      this.contracts.erc20Recover = erc20Recover;
      this.mocks.mainToken = mainToken;
      this.mocks.thirdPartyToken = thirdPartyToken;
    });

    shouldBehaveLikeERC20Recover();
  });
}
