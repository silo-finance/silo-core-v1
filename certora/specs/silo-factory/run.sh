#!/bin/bash

certoraRun contracts/SiloFactory.sol \
    --verify SiloFactory:certora/specs/silo-factory/SiloFactory.spec \
    --staging \
    --msg "Silo factory" \
    --optimistic_loop \
    --send_only
