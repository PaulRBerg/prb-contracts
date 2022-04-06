import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import type { ERC20GodMode } from "../../src/types/ERC20GodMode";
import type { GodModeERC20__factory } from "../../src/types/factories/GodModeERC20__factory";

task("deploy:ERC20GodMode")
  .addParam("name", "The ERC-20 name of the token")
  .addParam("symbol", "The ERC-20 symbol of the token")
  .addParam("decimals", "The ERC-20 decimals of the token")
  .setAction(async function (taskArguments: TaskArguments, { ethers }) {
    const erc20GodModeFactory: GodModeERC20__factory = <GodModeERC20__factory>(
      await ethers.getContractFactory("ERC20GodMode")
    );
    const erc20GodMode: ERC20GodMode = <ERC20GodMode>(
      await erc20GodModeFactory.deploy(taskArguments.name, taskArguments.symbol, taskArguments.decimals)
    );
    await erc20GodMode.deployed();
    console.log("ERC20GodMode deployed to: ", erc20GodMode.address);
  });
