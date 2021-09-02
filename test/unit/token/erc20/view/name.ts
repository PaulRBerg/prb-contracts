import { expect } from "chai";

import { ERC20_NAME } from "../../../../../helpers/constants";

export default function shouldBehaveLikeNameGetter(): void {
  it("retrieves the name", async function () {
    const name: string = await this.contracts.erc20.name();
    expect(name).to.equal(ERC20_NAME);
  });
}
