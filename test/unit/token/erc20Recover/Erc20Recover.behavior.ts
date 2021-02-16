import shouldBehaveLikeIsRecoverInitialized from "./view/isRecoverInitialized";

import shouldBehaveLikeRecover from "./effects/recover";
import shouldBehaveLikeSetNonRecoverableTokens from "./effects/setNonRecoverableTokens";

export function shouldBehaveLikeErc20Recover(): void {
  describe("View", function () {
    describe("isRecoverInitialized", function () {
      shouldBehaveLikeIsRecoverInitialized();
    });
  });

  describe("Effects", function () {
    describe("recover", function () {
      shouldBehaveLikeRecover();
    });

    describe("setNonRecoverableTokens", function () {
      shouldBehaveLikeSetNonRecoverableTokens();
    });
  });
}
