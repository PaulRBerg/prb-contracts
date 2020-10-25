import { expect } from "chai";

import { PERMIT_TYPEHASH } from "../../../../helpers/eip2612";

export default function shouldBehaveLikePermitTypehashGetter(): void {
  it("retrieves the proper permit typehash", async function () {
    const contractPermitTypehash: string = await this.contracts.erc20Permit.PERMIT_TYPEHASH();
    expect(contractPermitTypehash).to.equal(PERMIT_TYPEHASH);
  });
}
