import { config as dotenvConfig } from "dotenv";
import { resolve } from "path";
dotenvConfig({ path: resolve(__dirname, "./.env") });

import { BuidlerConfig, usePlugin } from "@nomiclabs/buidler/config";
import { BuidlerNetworkAccount, HDAccountsConfig } from "@nomiclabs/buidler/types";
import { ChainIds, DefaultPrivateKeys } from "./utils/constants";

import "./tasks/accounts";
import "./tasks/clean";
import "./tasks/typechain";

usePlugin("@nomiclabs/buidler-waffle");
usePlugin("solidity-coverage");

/**
 * Five accounts with 10,000 ETH each. We need to use these instead of the default
 * Buidler accounts because some tests depend on hardcoded private keys.
 *
 * 0xf4c0b91D62BD7e3d66e4c894D8AaC397316F5706
 * 0x0CFf1DE14277E3FC4e6983Be93B460d7B891088e
 * 0x4B86007C31C780087aF7eb8f97d65c7b3Ef9db0A
 * 0xA964A47b458eb3759a1290ac57198537dBaa41EC
 * 0x32BBA47c034f5a5530D573974DC968c4DdB037A9
 */
function createBuidlerEvmAccounts(): BuidlerNetworkAccount[] {
  const tenThousandEther: string = "10000000000000000000000";
  return [
    {
      balance: tenThousandEther,
      privateKey: DefaultPrivateKeys.Alice,
    },
    {
      balance: tenThousandEther,
      privateKey: DefaultPrivateKeys.Bob,
    },
    {
      balance: tenThousandEther,
      privateKey: DefaultPrivateKeys.Carol,
    },
    {
      balance: tenThousandEther,
      privateKey: DefaultPrivateKeys.David,
    },
    {
      balance: tenThousandEther,
      privateKey: DefaultPrivateKeys.Eve,
    },
  ];
}

/**
 * @dev You must have a `.env` file. Follow the example in `.env.example`.
 * @param {string} network The name of the testnet
 */
function createNetworkConfig(network?: string): { accounts: HDAccountsConfig; url: string | undefined } {
  if (!process.env.MNEMONIC) {
    throw new Error("Please set your MNEMONIC in a .env file");
  }

  if (!process.env.INFURA_API_KEY) {
    throw new Error("Please set your INFURA_API_KEY");
  }

  return {
    accounts: {
      count: 10,
      initialIndex: 0,
      mnemonic: process.env.MNEMONIC,
      path: "m/44'/60'/0'/0",
    },
    url: network ? `https://${network}.infura.io/v3/${process.env.INFURA_API_KEY}` : undefined,
  };
}

const config: BuidlerConfig = {
  defaultNetwork: "buidlerevm",
  networks: {
    buidlerevm: {
      accounts: createBuidlerEvmAccounts(),
      chainId: ChainIds.BuidlerEvm,
    },
    coverage: {
      chainId: ChainIds.Ganache,
      url: "http://127.0.0.1:8555",
    },
    goerli: {
      ...createNetworkConfig("goerli"),
      chainId: 5,
    },
    kovan: {
      ...createNetworkConfig("kovan"),
      chainId: 42,
    },
    rinkeby: {
      ...createNetworkConfig("rinkeby"),
      chainId: 4,
    },
    ropsten: {
      ...createNetworkConfig("ropsten"),
      chainId: 3,
    },
  },
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    coverage: "./coverage",
    coverageJson: "./coverage.json",
    root: "./",
    sources: "./contracts",
    tests: "./test",
  },
  solc: {
    /* https://buidler.dev/buidler-evm/#solidity-optimizer-support */
    optimizer: {
      enabled: false,
      runs: 200,
    },
    version: "0.7.3",
  },
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
  },
};

export default config;
