#!/bin/bash
# requires solidity 0.7.6

certoraRun contracts/priceProviders/balancerV2/BalancerV2PriceProvider.sol \
    certora/mocks/PricePriovidersRepository076.sol \
    --link BalancerV2PriceProvider:priceProvidersRepository=PricePriovidersRepository076 \
    --verify BalancerV2PriceProvider:certora/specs/price-providers/balancer-v2/BalancerV2.spec \
    --staging alex/to-skey-vs-max-solidity-slot \
    --msg "BalancerV2 price provider" \
    --optimistic_loop \
    --send_only
