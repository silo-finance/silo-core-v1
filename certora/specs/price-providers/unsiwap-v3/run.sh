#!/bin/bash

certoraRun certora/harness/UniswapV3PriceProviderHarness.sol \
    certora/mocks/PricePriovidersRepository076.sol \
    --link UniswapV3PriceProviderHarness:priceProvidersRepository=PricePriovidersRepository076 \
    --verify UniswapV3PriceProviderHarness:certora/specs/price-providers/unsiwap-v3/UniswapV3PriceProvider.spec \
    --staging alex/to-skey-vs-max-solidity-slot \
    --msg "UniswapV3 price provider" \
    --optimistic_loop \
    --send_only
