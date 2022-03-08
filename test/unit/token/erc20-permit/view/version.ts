import { expect } from "chai";

export default function shouldBehaveLikeVersionGetter(): void {
  it("retrieves the version", async function () {
    const version: string = await this.contracts.erc20Permit.version();
    expect(version).to.equal("1");
  });
}
