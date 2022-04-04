import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import type { GodModeERC20 } from "../../src/types/GodModeERC20";
import type { GodModeERC20__factory } from "../../src/types/factories/GodModeERC20__factory";

task("deploy:GodModeERC20")
  .addParam("name", "The ERC-20 name of the token")
  .addParam("symbol", "The ERC-20 symbol of the token")
  .addParam("decimals", "The ERC-20 decimals of the token")
  .setAction(async function (taskArguments: TaskArguments, { ethers }) {
    const godModeERC20Factory: GodModeERC20__factory = <GodModeERC20__factory>(
      await ethers.getContractFactory("GodModeERC20")
    );
    const godModeERC20: GodModeERC20 = <GodModeERC20>(
      await godModeERC20Factory.deploy(taskArguments.name, taskArguments.symbol, taskArguments.decimals)
    );
    await godModeERC20.deployed();
    console.log("GodModeERC20 deployed to: ", godModeERC20.address);
  });
