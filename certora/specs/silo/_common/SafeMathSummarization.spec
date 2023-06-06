methods {
    // Summarizations:
    toShare(uint256 amount, uint256 totalAmount, uint256 totalShares) returns (uint256) =>
        simplified_toShare(amount, totalAmount, totalShares)

    toShareRoundUp(uint256 amount, uint256 totalAmount, uint256 totalShares) returns (uint256) =>
        simplified_toShare_roundUp(amount, totalAmount, totalShares)

    toAmount(uint256 shares, uint256 totalAmount, uint256 totalShares) returns (uint256) =>
       simplified_toAmount(shares, totalAmount, totalShares)

    toAmountRoundUp(uint256 shares, uint256 totalAmount, uint256 totalShares) returns (uint256) =>
       simplified_toAmount_roundUp(shares, totalAmount, totalShares)

    toValue(uint256 _assetAmount, uint256 _assetPrice, uint256 _assetDecimals) returns (uint256) =>
        simplified_toValue(_assetAmount, _assetPrice, _assetDecimals)
}

//assume 1:2 ratio share per amount
function simplified_toShare(uint256 amount, uint256 totalAmount, uint256 totalShares) returns uint256 {
        return to_uint256(amount / 2);
}

function simplified_toAmount(uint256 share, uint256 totalAmount, uint256 totalShares) returns uint256 {
        require share * 2 <= max_uint256;
        return to_uint256(share * 2);
}

function simplified_toShare_roundUp(uint256 amount, uint256 totalAmount, uint256 totalShares) returns uint256 {
        return to_uint256(amount / 2 + 1);
}

function simplified_toAmount_roundUp(uint256 share, uint256 totalAmount, uint256 totalShares) returns uint256 {
        require share * 2 <= max_uint256;
        return to_uint256(share * 2 + 1);
}

// assume price is always 4
function simplified_toValue(uint256 assetAmount, uint256 assetPrice, uint256 assetDecimals) returns uint256 {
        require assetAmount * 4 <= max_uint256;
        return to_uint256(assetAmount * 4);
}
