import shouldBehaveLikeRecover from "./effects/recover";
import shouldBehaveLikeSetNonRecoverableTokens from "./effects/setNonRecoverableTokens";
import shouldBehaveLikeIsRecoverInitialized from "./view/isRecoverInitialized";

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
