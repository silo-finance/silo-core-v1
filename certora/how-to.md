# How to start with Silo's formal verification rules

## Certora Prover installation

Follow the installation guide for the Certora Prover here:
https://docs.certora.com/en/latest/docs/user-guide/getting-started/install.html

Once you have installed the prover, please run a small example to verify that everything is set up properly. You can
follow short guide here:
https://docs.certora.com/en/latest/docs/user-guide/getting-started/running.html

## Install solidity compiler

As the Silo repository have contracts with different solidity version for flexibility in the compiler installation, we
use solc-select. Please, follow the instructions for installation here:
https://github.com/crytic/solc-select

then:

```shell
solc-select install 0.8.13 && solc-select install 0.7.6
solc-select use 0.8.13

# for Uniswap:
solc-select use 0.7.6
```

## Certora Key

Set environmental variable `CERTORAKEY` to be able to run the Prover.

```shell
export CERTORAKEY=<premium_key>
```

## Run rules

To run all rules use a command: `bash certora/certoraRun.sh`

### Run rule for a particular component

Each directory with formal verification specifications for the component has a `run.sh` script, which contains
instructions on running rules for this component.

For example, we can run only silo rules with command: `bash certora/specs/silo/run.sh`

## Certora's learning tutorials

- Certora Tutorials: a set of lessons that teaches the Certora Verification Language and how to approach formal
  verification. The tutorial is suitable for every level -- beginner to advanced:
  https://github.com/Certora/Tutorials

- Certora Documentation: the Certora Prover Users' Guide explains how to use the Prover, while the Reference Manual
  contains the complete details of all tool features:
  https://docs.certora.com/en/latest/index.html

- Certora Forum: A space to ask the community and the Certora team technical questions, discuss and suggest new
  features:
  https://forum.certora.com/

- Certora Discord Channel:
  https://discord.gg/uU2VSHnY

## Troubleshoot and tips

```
CRITICAL: /usr/local/bin/solc had an error:
/Users/projects/neoRacer/silo-contracts/contracts/priceProviders/uniswapV3/UniswapV3PriceProvider.sol:6:1: ParserError: Source "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol" not found: File not found.
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
```

**Fix:** make use package is included under `dependencies` secion (not `devDependencies`!).

Flag for one rule debugging  
`--rule UT_UniswapV3PriceProviderV2_verifyPools`