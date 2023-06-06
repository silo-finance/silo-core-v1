#!/bin/bash

certoraRun certora/harness/ChainlinkV3PriceProviderHarness.sol \
    contracts/PriceProvidersRepository.sol \
    --link ChainlinkV3PriceProviderHarness:priceProvidersRepository=PriceProvidersRepository \
    --verify ChainlinkV3PriceProviderHarness:certora/specs/price-providers/chainlink/Chainlink.spec \
    --msg "Chainlink price provider" \
    --optimistic_loop \
    --send_only
