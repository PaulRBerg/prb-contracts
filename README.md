# PRBContracts [![GitHub Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: MIT][license-badge]][license]

[gha]: https://github.com/PaulRBerg/prb-contracts/actions
[gha-badge]: https://github.com/PaulRBerg/prb-contracts/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg
[license]: https://opensource.org/licenses/MIT
[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

Off-the-shelf Solidity smart contracts.

- Designed for Solidity >=0.8.4
- Uses custom errors instead of revert reason strings
- Complementary to [OpenZeppelin's library](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Well-documented via NatSpec comments
- Thoroughly tested with Foundry

I initially created this library to streamline my personal workflow, as I was tired of having to maintain identical
contracts across multiple repositories. However, if you find this library beneficial to your own projects, that's a
win-win situation for both of us.

## Install

### Foundry

First, run the install step:

```sh
forge install --no-commit PaulRBerg/prb-contracts@v5
```

Your `.gitmodules` file should now contain the following entry:

```toml
[submodule "lib/prb-contracts"]
  branch = "v5"
  path = "lib/prb-contracts"
  url = "https://github.com/PaulRBerg/prb-contracts"
```

Finally, add this to your `remappings.txt` file:

```text
@prb/contracts/=lib/prb-contracts/src/
```

### Hardhat

```sh
pnpm add @prb/contracts
```

## Usage

Once installed, you can use the contracts like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { ERC20 } from "@prb/contracts/token/erc20/ERC20.sol";
import { ERC20Permit } from "@prb/contracts/token/erc20/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
  constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20Permit(name_, symbol_, decimals_) {}
}
```

## Contributing

Feel free to dive in! [Open](https://github.com/PaulRBerg/prb-proxy/issues/new) an issue,
[start](https://github.com/PaulRBerg/prb-proxy/discussions/new) a discussion or submit a PR.

### Pre Requisites

You will need the following software on your machine:

- [Git](https://git-scm.com/downloads)
- [Foundry](https://github.com/foundry-rs/foundry)
- [Node.Js](https://nodejs.org/en/download/)
- [Pnpm](https://pnpm.io)

In addition, familiarity with [Solidity](https://soliditylang.org/) is requisite.

### Set Up

Clone this repository including submodules:

```sh
$ git clone --recurse-submodules -j8 git@github.com:PaulRBerg/prb-contracts.git
```

Then, inside the project's directory, run this to install the Node.js dependencies:

```sh
$ pnpm install
```

Now you can start making changes.

### Syntax Highlighting

You will need the following VSCode extensions:

- [hardhat-solidity](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity)
- [vscode-tree-language](https://marketplace.visualstudio.com/items?itemName=CTC.vscode-tree-extension)

## Security

While I have strict standards for code quality and test coverage, it's important to note that this project may not be
entirely risk-free. Although I have taken measures to ensure the security of the contracts, they have not yet been
audited by a third-party security researcher.

### Caveat Emptor

Please be aware that this software is experimental and is provided on an "as is" and "as available" basis. I do not
offer any warranties, and I cannot be held responsible for any direct or indirect loss resulting from the continued use
of this codebase.

### Contact

If you discover any bugs or security issues, please report them via [Telegram](https://t.me/PaulRBerg).

## Related Efforts

- [openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Alberto Cuesta Cañada's [ERC20Permit](https://github.com/alcueca/ERC20Permit) and
  [Orchestrated](https://github.com/alcueca/Orchestrated)

## License

This project is licensed under MIT.
