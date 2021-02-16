import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { task } from "hardhat/config";

task("accounts", "Prints the list of accounts", async (_taskArgs, hre) => {
  const signers: SignerWithAddress[] = await hre.ethers.getSigners();

  for (const signer of signers) {
    console.log(signer.address);
  }
});
