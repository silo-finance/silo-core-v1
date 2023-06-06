#!/bin/bash

certoraRun certora/harness/UniswapV3PriceProviderV2Harness.sol \
    certora/mocks/PricePriovidersRepository076.sol \
    --link UniswapV3PriceProviderV2Harness:priceProvidersRepository=PricePriovidersRepository076 \
    --verify UniswapV3PriceProviderV2Harness:certora/specs/price-providers/unsiwap-v3-v2/UniswapV3PriceProviderV2.spec \
    --msg "UniswapV3 price provider V2" \
    --optimistic_loop \
    --loop_iter 2 \
    --send_only \
    --rule VC_UniswapV3PriceProviderV2_assetPath

