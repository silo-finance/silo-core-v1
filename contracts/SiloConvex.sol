// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./SiloV2.sol";
import "./interfaces/ISiloConvexStateChangesHandler.sol";

/// @notice Modification of the Silo for ConvexSiloWrapper tokens.
/// The Silo asset can be used only as a collateral only asset and can't be borrowed. Convex rewards are checkpointed
/// for the user on every collateral state change.
contract SiloConvex is SiloV2 {
    /// @dev Checkpoints user's rewards, verifies the ConvexSiloWrapper setup. This code can not be implemented in
    /// Silo contract because of the smart contract bytecode limit.
    // solhint-disable-next-line var-name-mixedcase
    ISiloConvexStateChangesHandler internal immutable _STATE_CHANGES_HANDLER;

    /// @dev Revert when Silo asset is not a ConvexSiloWrapper. Also reverts when the Curve pool can not be fetched for
    /// the underlying Curve LP token.
    error InvalidWrapper();

    /// @dev Revert when Silo asset is being borrowed, that is prohibited.
    error SiloAssetBorrowed();

    constructor (
        ISiloRepository _repository,
        ISiloConvexStateChangesHandler _stateChangesHandler,
        address _siloAsset,
        uint128 _version
    )
        SiloV2(_repository, _siloAsset, _version)
    {
        _STATE_CHANGES_HANDLER = _stateChangesHandler;

        if (!_stateChangesHandler.wrapperSetupVerification(_siloAsset)) revert InvalidWrapper();
    }

    /// @inheritdoc ISilo
    function deposit(address _asset, uint256 _amount, bool _collateralOnly)
        external
        virtual
        override
        returns (uint256 collateralAmount, uint256 collateralShare)
    {
        // IMPORTANT - keep `_beforeBalanceUpdate` at the beginning of the function
        _beforeBalanceUpdate(msg.sender, address(0));
        _assetIsCollateralOnly(_asset, _collateralOnly);

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
        returns (uint256 collateralAmount, uint256 collateralShare)
    {
        // IMPORTANT - keep `_beforeBalanceUpdate` at the beginning of the function
        _beforeBalanceUpdate(msg.sender, _depositor);
        _assetIsCollateralOnly(_asset, _collateralOnly);

        return _deposit(_asset, msg.sender, _depositor, _amount, _collateralOnly);
    }

    /// @inheritdoc ISilo
    function withdraw(address _asset, uint256 _amount, bool _collateralOnly)
        external
        virtual
        override
        returns (uint256 withdrawnAmount, uint256 withdrawnShare)
    {
        // IMPORTANT - keep `_beforeBalanceUpdate` at the beginning of the function
        _beforeBalanceUpdate(msg.sender, address(0));

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
        returns (uint256 withdrawnAmount, uint256 withdrawnShare)
    {
        // IMPORTANT - keep `_beforeBalanceUpdate` at the beginning of the function
        _beforeBalanceUpdate(_depositor, _receiver);

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
        if (_isSiloAsset(_asset)) revert SiloAssetBorrowed();

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
        if (_isSiloAsset(_asset)) revert SiloAssetBorrowed();

        return _borrow(_asset, _borrower, _receiver, _amount);
    }

    /// @inheritdoc ISilo
    function flashLiquidate(address[] calldata _users, bytes calldata _flashReceiverData)
        external
        virtual
        override
        returns (
            address[] memory assets,
            uint256[][] memory receivedCollaterals,
            uint256[][] memory shareAmountsToRepay
        )
    {
        assets = getAssets();
        uint256 usersLength = _users.length;
        receivedCollaterals = new uint256[][](usersLength);
        shareAmountsToRepay = new uint256[][](usersLength);

        for (uint256 i = 0; i < usersLength;) {
            // IMPORTANT - keep `_beforeBalanceUpdate` here and do not add any new actions before
            // this function call. This function can not be moved outside of a loop, otherwise the contract size limit
            // will be exceeded.
            _beforeBalanceUpdate(_users[i], address(0));

            (
                receivedCollaterals[i],
                shareAmountsToRepay[i]
            ) = _userLiquidation(assets, _users[i], IFlashLiquidationReceiver(msg.sender), _flashReceiverData);

            // `i` has the same type as `usersLength`.
            // Because of the condition `i < usersLength` overflow is not possible
            unchecked { i++; }
        }
    }

    /// @notice Rewards checkpoint
    /// @dev It is not possible to pass an array of addresses to checkpoint because of the smart contract size limit.
    /// Both parameters can be zero, checkpointing will be skipped in this case.
    /// @param _firstToCheckpoint address to checkpoint, can be zero.
    /// @param _secondToCheckpoint address to checkpoint, can be zero.
    function _beforeBalanceUpdate(address _firstToCheckpoint, address _secondToCheckpoint) internal virtual {
        _STATE_CHANGES_HANDLER.beforeBalanceUpdate(_firstToCheckpoint, _secondToCheckpoint);
    }

    /// @dev Revert on a deposit with a silo asset marked as not collateral only
    /// @dev Revert on a withdrawal if a silo asset will be withdrawn as not collateral only
    /// @param _asset Asset to be deposited/withdrawn into/from the silo
    /// @param _collateralOnly Flag whether the deposit/withdrawal is collateral only or not
    function _assetIsCollateralOnly(address _asset, bool _collateralOnly) internal virtual view {
        // We can't revert with reason string, because the revert reason will cause the size of this contract to exceed
        // the gas limit.
        if (_isSiloAsset(_asset) && !_collateralOnly) revert(); // solhint-disable-line reason-string
    }

    /// @dev Check if the asset is the silo asset
    /// @param _asset Asset to be deposited/withdrawn into/from the silo
    function _isSiloAsset(address _asset) internal view returns (bool) {
        return _asset == siloAsset;
    }
}
