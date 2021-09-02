import { expect } from "chai";

import { ERC20_SYMBOL } from "../../../../../helpers/constants";

export default function shouldBehaveLikeSymbolGetter(): void {
  it("retrieves the symbol", async function () {
    const symbol: string = await this.contracts.erc20.symbol();
    expect(symbol).to.equal(ERC20_SYMBOL);
  });
}
