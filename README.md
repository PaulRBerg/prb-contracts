# Contracts [![Coverage Status](https://coveralls.io/repos/github/paulrberg/contracts/badge.svg?branch=main)](https://coveralls.io/github/paulrberg/contracts?branch=main) [![Styled with Prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://prettier.io) [![Commitizen Friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/) [![license: Unlicense](https://img.shields.io/badge/license-Unlicense-yellow.svg)](https://spdx.org/licenses/Unlicense.html)

**Off-the-shelf Solidity smart contracts.** Built with my beloved [Solidity template](https://github.com/PaulRBerg/solidity-template).

- Designed for Solidity >=0.8.4
- Complementary to [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Promotes [PRBMath](https://github.com/hifi-finance/prb-math) as a fixed-point math library for Solidity
- Well-documented via NatSpec comments
- Thoroughly tested with Hardhat and Waffle

I created this library for my own use, to avoid having to maintain the same contracts in different repositories. If you find
it useful too, that's a win-win.

## Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties and will not be liable for any loss, direct or indirect through continued use of this codebase.

## Install

With yarn:

```sh
$ yarn add @paulrberg/contracts
```

Or npm:

```sh
$ npm install @paulrberg/contracts
```

## Usage

Once installed, you can use the contracts like this:

```solidity
// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "@paulrberg/contracts/token/erc20/Erc20.sol";
import "@paulrberg/contracts/token/erc20/Erc20Permit.sol";

contract MyToken is Erc20, Erc20Permit {
  constructor(
    string memory name_,
    string memory symbol_,
    uint8 decimals_
  ) Erc20Permit(name_, symbol_, decimals_) {}
}

```

## Contributing

Feel free to dive in! [Open](https://github.com/paulrberg/prb-proxy/issues/new) an issue,
[start](https://github.com/paulrberg/prb-proxy/discussions/new) a discussion or submit a PR.

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Node.Js](https://nodejs.org/en/download/)
- [Yarn](https://yarnpkg.com/getting-started/install)

In addition, familiarity with [Solidity](https://soliditylang.org/), [TypeScript](https://typescriptlang.org/) and [Hardhat](https://hardhat.org) is requisite.

### Set Up

Install the dependencies:

```bash
$ yarn install
```

Then, follow the `.env.example` file to add the requisite environment variables in the `.env` file. Now you can start making changes.

## Security

While I set a high bar for code quality and test coverage, you shouldn't assume that this project is completely safe to use. The contracts
have not been audited by a security researcher.

### Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties
and will not be liable for any loss, direct or indirect through continued use of this codebase.

### Contact

If you discover any security issues, please report them via [Keybase](https://keybase.io/paulrberg).

## Related Efforts

- [openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Alberto Cuesta Cañada's [ERC20Permit](https://github.com/alcueca/ERC20Permit) and [Orchestrated](https://github.com/alcueca/Orchestrated)

## License

[Unlicense](./LICENSE.md) © Paul Razvan Berg
