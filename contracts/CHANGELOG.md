# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2022-04-04

### Changed

- Refactor the `Erc` prefix into `ERC` in all `ERC-20` references ([#25](https://github.com/paulrberg/prb-contracts/issues/25)) (@paulrberg)

### Removed

- The `Admin` and `IAdmin` contracts and their related bindings (@paulrberg)

## [3.9.0] - 2022-04-03

### Changed

- Define the custom errors in the smart contract interface files (@paulrberg)

## [3.8.1] - 2022-03-11

### Fixed

- Include `CHANGELOG`, `LICENSE` and `README` in the package shipped to npm (@paulrberg)

## [3.8.0] - 2022-03-08

### Changed

- Change the package name from `@paulrberg/contracts` to `@prb/contracts` (@paulrberg)
- Switch from `prb-math` package to `@prb/math` (@paulrberg)
- Update links in README and `package.json` files (@paulrberg)

### Fixed

- Fix the EIP-2612 permit typehash ([#24](https://github.com/paulrberg/prb-contracts/pull/24)) (@surbhiaudichya)

[4.0.0]: https://github.com/paulrberg/prb-contracts/compare/v3.9.0...v4.0.0
[3.9.0]: https://github.com/paulrberg/prb-contracts/compare/v3.8.1...v3.9.0
[3.8.1]: https://github.com/paulrberg/prb-contracts/compare/v3.8.0...v3.8.1
[3.8.0]: https://github.com/paulrberg/prb-contracts/releases/tag/v3.8.0
