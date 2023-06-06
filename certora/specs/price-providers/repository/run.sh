#!/bin/bash

certoraRun contracts/PriceProvidersRepository.sol \
    --verify PriceProvidersRepository:certora/specs/price-providers/repository/PriceProvidersRepository.spec \
    --staging alex/to-skey-vs-max-solidity-slot \
    --msg "Price providers repository" \
    --optimistic_loop \
    --send_only
