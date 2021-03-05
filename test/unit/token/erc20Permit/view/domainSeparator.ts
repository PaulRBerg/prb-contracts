import { expect } from "chai";
import hre from "hardhat";

import { chainIds, erc20PermitConstants } from "../../../../../helpers/constants";
import { getDomainSeparator } from "../../../../../helpers/eip2612";

export default function shouldBehaveLikePermitTypehashGetter(): void {
  it("retrieves the proper domain separator", async function () {
    const domainSeparator = getDomainSeparator(
      erc20PermitConstants.name,
      hre.network.config.chainId || chainIds.hardhat,
      this.contracts.erc20Permit.address,
    );
    const contractDomainSeparator: string = await this.contracts.erc20Permit.DOMAIN_SEPARATOR();
    expect(contractDomainSeparator).to.equal(domainSeparator);
  });
}
