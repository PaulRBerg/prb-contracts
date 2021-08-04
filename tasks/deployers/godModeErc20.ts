import { task } from "hardhat/config";
import { TaskArguments } from "hardhat/types";

import { GodModeErc20, GodModeErc20__factory } from "../../typechain";

task("deploy:GodModeErc20")
  .addParam("name", "The ERC-20 name of the token")
  .addParam("symbol", "The ERC-20 symbol of the token")
  .addParam("decimals", "The ERC-20 decimals of the token")
  .setAction(async function (taskArguments: TaskArguments, { ethers }) {
    const godModeErc20Factory: GodModeErc20__factory = await ethers.getContractFactory("GodModeErc20");
    const godModeErc20: GodModeErc20 = <GodModeErc20>(
      await godModeErc20Factory.deploy(taskArguments.name, taskArguments.symbol, taskArguments.decimals)
    );
    await godModeErc20.deployed();
    console.log("GodModeErc20 deployed to: ", godModeErc20.address);
  });
