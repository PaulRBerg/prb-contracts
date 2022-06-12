import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import { config as dotenvConfig } from "dotenv";
import type { HardhatUserConfig } from "hardhat/config";
import type { NetworkUserConfig } from "hardhat/types";
import { resolve } from "path";
import "solidity-coverage";

import { getEnvVar } from "./helpers/env";

// import "./tasks/clean";
// import "./tasks/deploy";

dotenvConfig({ path: resolve(__dirname, "./.env") });

const chainIds = {
  hardhat: 31337,
  mainnet: 1,
  rinkeby: 4,
};

// Ensure that we have all the environment variables we need.
const mnemonic: string = getEnvVar("MNEMONIC");
const infuraApiKey: string = getEnvVar("INFURA_API_KEY");

function getChainConfig(network: keyof typeof chainIds): NetworkUserConfig {
  const url: string = "wss://" + network + ".infura.io/ws/v3/" + infuraApiKey;
  return {
    accounts: {
      count: 10,
      mnemonic,
      path: "m/44'/60'/0'/0",
    },
    chainId: chainIds[network],
    url,
  };
}

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
      },
      chainId: chainIds.hardhat,
    },
    localhost: {
      accounts: {
        mnemonic,
      },
      url: "http://localhost:8545",
    },
    rinkeby: getChainConfig("rinkeby"),
  },
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    sources: "./contracts",
    tests: "./test",
  },
  solidity: {
    version: "0.8.14",
    settings: {
      metadata: {
        bytecodeHash: "none",
      },
      optimizer: {
        enabled: true,
        runs: 800,
      },
    },
  },
  typechain: {
    outDir: "src/types",
    target: "ethers-v5",
  },
};

export default config;
