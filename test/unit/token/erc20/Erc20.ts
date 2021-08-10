import { erc20Fixture } from "../../../shared/fixtures";
import { shouldBehaveLikeErc20 } from "./Erc20.behavior";

export function testErc20(): void {
  describe("Erc20", function () {
    beforeEach(async function () {
      const { erc20 } = await this.loadFixture(erc20Fixture);
      this.contracts.erc20 = erc20;
    });
    shouldBehaveLikeErc20();
  });
}
