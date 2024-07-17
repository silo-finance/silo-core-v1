// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../SiloCollateralOnly.sol";
import "./SiloFactoryV2.sol";

/// @title SiloCollateralOnlyFactory
/// @notice Silo Factory has one job, deploy Silo implementation
/// @dev Silo Factory is registered within SiloRepository contract and it's given a version. Each version
/// is different Silo Factory that deploys different Silo implementation. Many Factory contracts can be
/// registered with the Repository contract.
/// @custom:security-contact security@silo.finance
contract SiloCollateralOnlyFactory is SiloFactoryV2 {
    /// @param _repository A silo repository address
    constructor(address _repository) SiloFactoryV2(_repository) {
        // initial setup is done in SiloFactoryV2, nothing to do here
    }

    /// @inheritdoc ISiloFactoryV2
    function createSilo(
        address _siloAsset,
        uint128 _version,
        bytes memory
    )
        external
        virtual
        override
        returns (address silo)
    {
        // Only allow silo repository
        if (msg.sender != siloRepository) revert OnlyRepository();

        silo = address(new SiloCollateralOnly(ISiloRepository(msg.sender), _siloAsset, _version));
        emit NewSiloCreated(silo, _siloAsset, _version);
    }
}
