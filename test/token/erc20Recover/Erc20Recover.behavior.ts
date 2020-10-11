import shouldBehaveLikeIsInitialized from "./view/isInitialized";

import shouldBehaveLikeRecover from "./effects/recover";
import shouldBehaveLikeSetNonRecoverableTokens from "./effects/setNonRecoverableTokens";

export function shouldBehaveLikeErc20Recover(): void {
  describe("View", function () {
    describe("isInitialized", function () {
      shouldBehaveLikeIsInitialized();
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
