// SPDX-License-Identifier: MIT

/// @title KIP-7 Fungible Token Standard, optional metadata extension
///  Note: the KIP-13 identifier for this interface is 0xa219a025.
interface IKIP7Metadata {
    /// @notice Returns the name of the token.
    function name() external view returns (string memory);

    /// @notice Returns the symbol of the token, usually a shorter version of the
    /// name.
    function symbol() external view returns (string memory);

    /// @notice Returns the number of decimals used to get its user representation.
    /// For example, if `decimals` equals `2`, a balance of `505` tokens should
    /// be displayed to a user as `5,05` (`505 / 10 ** 2`).
    ///  Tokens usually opt for a value of 18, imitating the relationship between
    /// KLAY and Peb.
    /// NOTE: This information is only used for _display_ purposes: it in
    /// no way affects any of the arithmetic of the contract, including
    /// `IKIP7.balanceOf` and `IKIP7.transfer`.
    /// @return The number of decimals of this token.
    function decimals() external view returns (uint8);
}

