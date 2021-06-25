import { expect } from "chai";
import hre from "hardhat";

import { ERC20_PERMIT_NAME, HARDHAT_CHAIN_ID } from "../../../../../helpers/constants";
import { getDomainSeparator } from "../../../../shared/eip2612";

export default function shouldBehaveLikePermitTypehashGetter(): void {
  it("retrieves the proper domain separator", async function () {
    const domainSeparator = getDomainSeparator(
      ERC20_PERMIT_NAME,
      hre.network.config.chainId || HARDHAT_CHAIN_ID.toNumber(),
      this.contracts.erc20Permit.address,
    );
    const contractDomainSeparator: string = await this.contracts.erc20Permit.DOMAIN_SEPARATOR();
    expect(contractDomainSeparator).to.equal(domainSeparator);
  });
}
