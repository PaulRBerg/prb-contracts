import { erc20Fixture } from "../../../shared/fixtures";
import { shouldBehaveLikeERC20 } from "./ERC20.behavior";

export function testERC20(): void {
  describe("ERC20", function () {
    beforeEach(async function () {
      const { erc20 } = await this.loadFixture(erc20Fixture);
      this.contracts.erc20 = erc20;
    });
    shouldBehaveLikeERC20();
  });
}
