import bre from "@nomiclabs/buidler";
import { expect } from "chai";

import { ChainIds, Erc20PermitConstants } from "../../../../helpers/constants";
import { getDomainSeparator } from "../../../../helpers/eip2612";

export default function shouldBehaveLikePermitTypehashGetter(): void {
  it("retrieves the proper domain separator", async function () {
    const domainSeparator = getDomainSeparator(
      Erc20PermitConstants.name,
      bre.network.config.chainId || ChainIds.BuidlerEvm,
      this.contracts.erc20Permit.address,
    );
    const contractDomainSeparator: string = await this.contracts.erc20Permit.DOMAIN_SEPARATOR();
    expect(contractDomainSeparator).to.equal(domainSeparator);
  });
}
