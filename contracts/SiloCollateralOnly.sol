// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./SiloV2.sol";

/// @notice Modification of the Silo where a siloAsset can be deposited
/// only as collateral only asset and can't be borrowed.
/// Such assets as Curve LP Tokens should be added only with trusted underlying pool assets.
/// Otherwise, we should consider a possibility of the Read-Only Reentrancy attack on a Curve Oracle.
/// More about attack vector and solution on how to avoid it:
/// https://chainsecurity.com/curve-lp-oracle-manipulation-post-mortem/
contract SiloCollateralOnly is SiloV2 {
    /// @dev Revert if deposit/withdraw operations performed with a silo asset are
    /// not marked as collateral only
    error SiloAssetIsCollateralOnly();

    /// @dev Revert on a deposit with a silo asset marked as not collateral only
    /// @dev Revert on a withdrawal if a silo asset will be withdrawn as not collateral only
    /// @param _asset Asset to be deposited/withdrawn into/from the silo
    /// @param _collateralOnly Flag whether the deposit/withtrawal is collateral only or not
    modifier assetIsCollateralOnly(address _asset, bool _collateralOnly) {
        if (_asset == siloAsset && !_collateralOnly) revert SiloAssetIsCollateralOnly();
        _;
    }

    constructor (ISiloRepository _repository, address _siloAsset, uint128 _version)
        SiloV2(_repository, _siloAsset, _version)
    {
        // initial setup is done in BaseSilo, nothing to do here
    }

    /// @inheritdoc ISilo
    function deposit(address _asset, uint256 _amount, bool _collateralOnly)
        external
        virtual
        override
        assetIsCollateralOnly(_asset, _collateralOnly)
        returns (uint256 collateralAmount, uint256 collateralShare)
    {
        return _deposit(_asset, msg.sender, msg.sender, _amount, _collateralOnly);
    }

    /// @inheritdoc ISilo
    function depositFor(
        address _asset,
        address _depositor,
        uint256 _amount,
        bool _collateralOnly
    )
        external
        virtual
        override
        assetIsCollateralOnly(_asset, _collateralOnly)
        returns (uint256 collateralAmount, uint256 collateralShare)
    {
        return _deposit(_asset, msg.sender, _depositor, _amount, _collateralOnly);
    }

    /// @inheritdoc ISilo
    function withdraw(address _asset, uint256 _amount, bool _collateralOnly)
        external
        virtual
        override
        assetIsCollateralOnly(_asset, _collateralOnly)
        returns (uint256 withdrawnAmount, uint256 withdrawnShare)
    {
        return _withdraw(_asset, msg.sender, msg.sender, _amount, _collateralOnly);
    }

    /// @inheritdoc ISilo
    function withdrawFor(
        address _asset,
        address _depositor,
        address _receiver,
        uint256 _amount,
        bool _collateralOnly
    )
        external
        virtual
        override
        onlyRouter
        assetIsCollateralOnly(_asset, _collateralOnly)
        returns (uint256 withdrawnAmount, uint256 withdrawnShare)
    {
        return _withdraw(_asset, _depositor, _receiver, _amount, _collateralOnly);
    }

        /// @inheritdoc ISilo
    function borrow(address _asset, uint256 _amount)
        external
        virtual
        override
        returns (uint256 debtAmount, uint256 debtShare)
    {
        // Revert on a attempt to borrow a Silo asset.
        if (_isSiloAsset(_asset)) revert(); // solhint-disable-line reason-string

        return _borrow(_asset, msg.sender, msg.sender, _amount);
    }

    /// @inheritdoc ISilo
    function borrowFor(address _asset, address _borrower, address _receiver, uint256 _amount)
        external
        virtual
        override
        onlyRouter
        returns (uint256 debtAmount, uint256 debtShare)
    {
        // Revert on a attempt to borrow a Silo asset.
        if (_isSiloAsset(_asset)) revert(); // solhint-disable-line reason-string

        return _borrow(_asset, _borrower, _receiver, _amount);
    }

    /// @dev Check if the asset is the silo asset
    /// @param _asset Asset to be deposited/withdrawn into/from the silo
    function _isSiloAsset(address _asset) internal view returns (bool) {
        return _asset == siloAsset;
    }
}
