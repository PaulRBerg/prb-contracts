import shouldBehaveLikeApprove from "./effects/approve";
import shouldBehaveLikeBurn from "./effects/burn";
import shouldBehaveLikeDecreaseAllowance from "./effects/decreaseAllowance";
import shouldBehaveLikeIncreaseAllowance from "./effects/increaseAllowance";
import shouldBehaveLikeMint from "./effects/mint";
import shouldBehaveLikeTransfer from "./effects/transfer";
import shouldBehaveLikeTransferFrom from "./effects/transferFrom";
import shouldBehaveLikeERC20BalanceOf from "./view/balanceOf";
import shouldBehaveLikeDecimalsGetter from "./view/decimals";
import shouldBehaveLikeNameGetter from "./view/name";
import shouldBehaveLikeSymbolGetter from "./view/symbol";

export function shouldBehaveLikeERC20(): void {
  describe("View Functions", function () {
    describe("balanceOf", function () {
      shouldBehaveLikeERC20BalanceOf();
    });

    describe("decimal", function () {
      shouldBehaveLikeDecimalsGetter();
    });

    describe("name", function () {
      shouldBehaveLikeNameGetter();
    });

    describe("symbol", function () {
      shouldBehaveLikeSymbolGetter();
    });
  });

  describe("Effects Functions", function () {
    describe("approve", function () {
      shouldBehaveLikeApprove();
    });

    describe("burn", function () {
      shouldBehaveLikeBurn();
    });

    describe("decreaseAllowance", function () {
      shouldBehaveLikeDecreaseAllowance();
    });

    describe("increaseAllowance", function () {
      shouldBehaveLikeIncreaseAllowance();
    });

    describe("mint", function () {
      shouldBehaveLikeMint();
    });

    describe("transfer", function () {
      shouldBehaveLikeTransfer();
    });

    describe("transferFrom", function () {
      shouldBehaveLikeTransferFrom();
    });
  });
}
