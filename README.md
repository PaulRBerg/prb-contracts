# PRBContracts [![GitHub Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![Styled with Prettier][prettier-badge]][prettier] [![License: MIT][license-badge]][license]

[gha]: https://github.com/paulrberg/prb-contracts/actions
[gha-badge]: https://github.com/paulrberg/prb-contracts/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[prettier]: https://prettier.io
[prettier-badge]: https://img.shields.io/badge/Code_Style-Prettier-ff69b4.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

Off-the-shelf Solidity smart contracts.

- Designed for Solidity >=0.8.4
- Uses custom errors instead of revert reason strings
- Complementary to [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Well-documented via NatSpec comments
- Thoroughly tested with Foundry

I created this library for my own use, to avoid having to maintain the same contracts in different repositories. If you
find it useful too, that's a win-win.

## Install

### Foundry

First, run the install step:

```sh
forge install --no-commit paulrberg/prb-contracts
```

Then, add the following line to your `remappings.txt` file:

```text
@prb/contracts/=lib/prb-contracts/src/
```

### Hardhat

```sh
yarn add @prb/contracts
```

## Usage

Once installed, you can use the contracts like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@prb/contracts/token/erc20/ERC20.sol";
import "@prb/contracts/token/erc20/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
  constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20Permit(name_, symbol_, decimals_) {}
}
```

## Contributing

Feel free to dive in! [Open](https://github.com/paulrberg/prb-proxy/issues/new) an issue,
[start](https://github.com/paulrberg/prb-proxy/discussions/new) a discussion or submit a PR.

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.Js](https://nodejs.org/en/download/)
- [Yarn](https://yarnpkg.com/)

In addition, familiarity with [Solidity](https://soliditylang.org/) is requisite.

### Set Up

Clone this repository including submodules:

```sh
$ git clone --recurse-submodules -j8 git@github.com:paulrberg/prb-contracts.git
```

Then, inside the project's directory, run this to install the Node.js dependencies:

```sh
$ yarn install
```

Now you can start making changes.

### Syntax Highlighting

You will need the following VSCode extensions:

- [vscode-solidity](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)
- [vscode-tree-language](https://marketplace.visualstudio.com/items?itemName=CTC.vscode-tree-extension)

## Security

While I set a high bar for code quality and test coverage, you shouldn't assume that this project is completely safe to
use. The contracts have not been audited by a security researcher.

### Caveat Emptor

This is experimental software and is provided on an "as is" and "as available" basis. I do not give any warranties and
will not be liable for any loss, direct or indirect through continued use of this codebase.

### Contact

If you discover any security issues, please contact me via [Keybase](https://keybase.io/paulrberg).

## Related Efforts

- [openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Alberto Cuesta Cañada's [ERC20Permit](https://github.com/alcueca/ERC20Permit) and
  [Orchestrated](https://github.com/alcueca/Orchestrated)

## License

[MIT](./LICENSE.md) © Paul Razvan Berg
