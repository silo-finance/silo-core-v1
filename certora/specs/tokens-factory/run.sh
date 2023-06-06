#!/bin/bash

certoraRun contracts/TokensFactory.sol \
    contracts/SiloRepository.sol \
    --link TokensFactory:siloRepository=SiloRepository \
    --verify TokensFactory:certora/specs/tokens-factory/TokensFactory.spec \
    --staging jtoman/dynamic-creation \
    --msg "Tokens factory" \
    --optimistic_loop \
    --send_only
