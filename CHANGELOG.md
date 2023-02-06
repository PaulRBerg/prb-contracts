# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Common Changelog](https://common-changelog.org/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

[5.0.1]: https://github.com/PaulRBerg/prb-contracts/compare/v5.0.0...v5.0.1
[5.0.0]: https://github.com/PaulRBerg/prb-contracts/compare/v4.1.1...v5.0.0
[4.1.1]: https://github.com/PaulRBerg/prb-contracts/compare/v4.1.0...v4.1.1
[4.1.0]: https://github.com/PaulRBerg/prb-contracts/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/PaulRBerg/prb-contracts/compare/v3.9.0...v4.0.0
[3.9.0]: https://github.com/PaulRBerg/prb-contracts/compare/v3.8.1...v3.9.0
[3.8.1]: https://github.com/PaulRBerg/prb-contracts/compare/v3.8.0...v3.8.1
[3.8.0]: https://github.com/PaulRBerg/prb-contracts/releases/tag/v3.8.0

## [5.0.1] - 2023-02-06

### Fixed

- Fix installation in Node.js projects with `pinst` (@PaulRBerg)

## [5.0.0] - 2023-02-06

### Changed

- Change license to MIT (@PaulRBerg)
- Delete the "\_" prefix from admin functions (@PaulRBerg)
- Improve custom error and function parameter names (@PaulRBerg)
- Improve documentation (@PaulRBerg)
- Improve formatting by running the latest Prettier plugin (@PaulRBerg)
- Improve wording and grammar in NatSpec comments (@PaulRBerg)
- Move contracts to `src` directory (@PaulRBerg)
- Perform approval before transfer in `transferFrom` (@PaulRBerg)
- Refactor `amount` to `value` in the `approve` function of the `ERC20` contract (@PaulRBerg)
- Refactor the `NonStandardERC20` contract to `NonCompliantERC20` (@PaulRBerg)
- Refactor `nonRecoverableTokens` to `tokenDenylist` in `ERC20Recover` (@PaulRBerg)
- Optimize calculations in the `approve`, `burn`, and `mint` functions of the `ERC20` contract (@PaulRBerg)
- Use named arguments in function calls (@PaulRBerg)

### Added

- Add new contract `Adminable`, which supersedes `Ownable` (@PaulRBerg)
- Add new contract `ERC20Normalizer` (@PaulRBerg)

### Removed

- Remove PRBMath re-exports (@PaulRBerg)
- Remove `Ownable` contract (@PaulRBerg)
- Remove `GodModeERC20` contract (@PaulRBerg)

## [4.1.1] - 2022-04-06

### Fixed

- Implement the constructor in the `NonStandardERC20` contract (@PaulRBerg)

## [4.1.0] - 2022-04-06

### Added

- Add `burn` and `mint` methods in the `NonStandardERC20` contract (@PaulRBerg)
- Add a new contract `ERC20GodMode` that replicates `GodModeERC20` (@PaulRBerg)

## [4.0.0] - 2022-04-04

### Changed

- Refactor the `Erc` prefix into `ERC` in all `ERC-20` references
  ([#25](https://github.com/PaulRBerg/prb-contracts/issues/25)) (@PaulRBerg)

### Removed

- The `Admin` and `IAdmin` contracts and their related bindings (@PaulRBerg)

## [3.9.0] - 2022-04-03

### Changed

- Define the custom errors in the smart contract interface files (@PaulRBerg)

## [3.8.1] - 2022-03-11

### Fixed

- Include `CHANGELOG`, `LICENSE` and `README` in the package shipped to npm (@PaulRBerg)

## [3.8.0] - 2022-03-08

### Changed

- Change the package name from `@PaulRBerg/contracts` to `@prb/contracts` (@PaulRBerg)
- Switch from `prb-math` package to `@prb/math` (@PaulRBerg)
- Update links in README and `package.json` files (@PaulRBerg)

### Fixed

- Fix the EIP-2612 permit typehash ([#24](https://github.com/PaulRBerg/prb-contracts/pull/24)) (@surbhiaudichya)
