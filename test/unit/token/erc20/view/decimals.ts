import { expect } from "chai";

import { ERC20_DECIMALS } from "../../../../../helpers/constants";

export default function shouldBehaveLikeDecimalsGetter(): void {
  it("retrieves the decimals", async function () {
    const decimals: number = await this.contracts.erc20.decimals();
    expect(decimals).to.equal(ERC20_DECIMALS);
  });
}
