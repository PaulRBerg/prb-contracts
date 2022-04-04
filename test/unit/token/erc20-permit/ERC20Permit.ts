import { erc20PermitFixture } from "../../../shared/fixtures";
import { shouldBehaveLikeERC20Permit } from "./ERC20Permit.behavior";

export function testERC20Permit(): void {
  describe("ERC20Permit", function () {
    beforeEach(async function () {
      const { erc20Permit } = await this.loadFixture(erc20PermitFixture);
      this.contracts.erc20Permit = erc20Permit;
    });

    shouldBehaveLikeERC20Permit();
  });
}
