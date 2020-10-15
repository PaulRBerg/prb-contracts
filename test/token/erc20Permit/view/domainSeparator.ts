import bre from "@nomiclabs/buidler";
import { expect } from "chai";

import { ChainIds, Erc20PermitConstants } from "../../../../utils/constants";
import { getDomainSeparator } from "../../../../utils/eip2612";

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
