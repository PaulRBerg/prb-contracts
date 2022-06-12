import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import type { ERC20GodMode__factory } from "../../src/types/factories/token/erc20/ERC20GodMode__factory";
import type { ERC20GodMode } from "../../src/types/token/erc20/ERC20GodMode";

task("deploy:ERC20GodMode")
  .addParam("name", "The ERC-20 name of the token")
  .addParam("symbol", "The ERC-20 symbol of the token")
  .addParam("decimals", "The ERC-20 decimals of the token")
  .setAction(async function (taskArguments: TaskArguments, { ethers }) {
    const erc20GodModeFactory: ERC20GodMode__factory = <ERC20GodMode__factory>(
      await ethers.getContractFactory("ERC20GodMode")
    );
    const erc20GodMode: ERC20GodMode = <ERC20GodMode>(
      await erc20GodModeFactory.deploy(taskArguments.name, taskArguments.symbol, taskArguments.decimals)
    );
    await erc20GodMode.deployed();
    console.log("ERC20GodMode deployed to: ", erc20GodMode.address);
  });
