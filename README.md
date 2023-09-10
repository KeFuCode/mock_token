# About
ERC20 and ERC721 contracts on Starknet using Cairo (version 2.2.0).

## Prerequisites
- [Cairo](https://github.com/starkware-libs/cairo)
- [Scarb](https://docs.swmansion.com/scarb)
- [Rust](https://www.rust-lang.org/tools/install)

## Installation
```base
git clone https://github.com/KeFuCode/mock_token.git
yarn 
```

## Build
```bash
scarb build
```
## Deploy
### ERC20
```bash
node ./scripts/goerli/01_deploy_mock_erc20.js
```

### ERC721
```bash
node ./scripts/goerli/02_deploy_mock_erc721.js
```
