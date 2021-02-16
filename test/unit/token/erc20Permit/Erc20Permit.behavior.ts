import shouldBehaveLikeDomainSeparatorGetter from "./view/domainSeparator";
import shouldBehaveLikePermitTypehashGetter from "./view/permitTypehash";
import shouldBehaveLikeVersionGetter from "./view/version";

import shouldBehaveLikePermit from "./effects/permit";

export function shouldBehaveLikeErc20Permit(): void {
  describe("View", function () {
    describe("DOMAIN_SEPARATOR", function () {
      shouldBehaveLikeDomainSeparatorGetter();
    });

    describe("PERMIT_TYPEHASH", function () {
      shouldBehaveLikePermitTypehashGetter();
    });

    describe("version", function () {
      shouldBehaveLikeVersionGetter();
    });
  });

  describe("Effects", function () {
    describe("permit", function () {
      shouldBehaveLikePermit();
    });
  });
}
