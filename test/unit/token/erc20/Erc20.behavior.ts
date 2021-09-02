import shouldBehaveLikeERC20BalanceOf from "./view/balanceOf";
import shouldBehaveLikeDecimalsGetter from "./view/decimals";
import shouldBehaveLikeNameGetter from "./view/name";
import shouldBehaveLikeSymbolGetter from "./view/symbol";

import shouldBehaveLikeERC20Approve from "./effects/approve";
import shouldBehaveLikeERC20Burn from "./effects/burn";
import shouldBehaveLikeERC20DecreaseAllowance from "./effects/decreaseAllowance";
import shouldBehaveLikeERC20IncreaseAllowance from "./effects/increaseAllowance";
import shouldBehaveLikeERC20Mint from "./effects/mint";
import shouldBehaveLikeERC20Transfer from "./effects/transfer";
import shouldBehaveLikeERC20TransferFrom from "./effects/transferFrom";

export function shouldBehaveLikeErc20(): void {
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
      shouldBehaveLikeERC20Approve();
    });

    describe("burn", function () {
      shouldBehaveLikeERC20Burn();
    });

    describe("decrease allowance", function () {
      shouldBehaveLikeERC20DecreaseAllowance();
    });

    describe("increase allowance", function () {
      shouldBehaveLikeERC20IncreaseAllowance();
    });

    describe("mint", function () {
      shouldBehaveLikeERC20Mint();
    });

    describe("transfer", function () {
      shouldBehaveLikeERC20Transfer();
    });

    describe("transfer from", function () {
      shouldBehaveLikeERC20TransferFrom();
    });
  });
}
