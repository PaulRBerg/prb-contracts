import { erc20PermitFixture } from "../../fixtures";
import { shouldBehaveLikeErc20Permit } from "./Erc20Permit.behavior";

export function testErc20Permit(): void {
  describe("Erc20 Permit", function () {
    beforeEach(async function () {
      const { erc20Permit } = await this.loadFixture(erc20PermitFixture);
      this.contracts.erc20Permit = erc20Permit;
    });

    shouldBehaveLikeErc20Permit();
  });
}
