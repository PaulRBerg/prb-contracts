const shell = require("shelljs");

module.exports = {
  istanbulReporter: ["html", "lcov"],
  providerOptions: {
    mnemonic: process.env.MNEMONIC,
  },
  skipFiles: ["access/Admin.sol", "access/IAdmin.sol", "math", "mocks", "test"],
};
