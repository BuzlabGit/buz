// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./KIP7/KIP7Lockable.sol";
import "./KIP7/KIP7Mintable.sol";
import "./interfaces/IKIP7Metadata.sol";
import "./library/KIP7Pausable.sol";
import "./library/Freezable.sol";
import "./library/Address.sol";

contract BuzLab is
    KIP7Lockable,
    KIP7Mintable,
    IKIP7Metadata,
    Freezable
{
    using Address for address;

    bytes4 private constant _KIP7_RECEIVED = 0x9d188c22;
    string constant private _name = "BuzLab";
    string constant private _symbol = "BUZ";
    uint8 constant private _decimals = 18;
    uint256 constant private _initial_supply = 200_000_000;

    constructor() Ownable() {
        _registerInterface(type(IKIP7Metadata).interfaceId);
        _cap = 900_000_000 * (10**uint256(_decimals));
        _mint(msg.sender, _initial_supply * (10**uint256(_decimals)));
    }

    function transfer(address recipient, uint256 amount)
        override
        public
        whenNotFrozen(msg.sender)
        whenNotPaused
        checkLock(msg.sender, amount)
        returns (bool success)
    {
        require(
            recipient != address(0),
            "BUZ/transfer : Should not send to zero address"
        );
        _transfer(msg.sender, recipient, amount);
        success = true;
    }

    function transferFrom(address sender, address recipient, uint256 amount)
        override
        public
        whenNotFrozen(sender)
        whenNotPaused
        checkLock(sender, amount)
        returns (bool success)
    {
        require(
            recipient != address(0),
            "BUZ/transferFrom : Should not send to zero address"
        );
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender] - amount
        );
        success = true;
    }

    function approve(address spender, uint256 amount)
        override
        public
        returns (bool success)
    {
        require(
            spender != address(0),
            "BUZ/approve : Should not approve zero address"
        );
        _approve(msg.sender, spender, amount);
        success = true;
    }

    function name() override external pure returns (string memory tokenName) {
        tokenName = _name;
    }

    function symbol() override external pure returns (string memory tokenSymbol) {
        tokenSymbol = _symbol;
    }

    function decimals() override external pure returns (uint8 tokenDecimals) {
        tokenDecimals = _decimals;
    }

    function safeTransfer(address recipient, uint256 amount, bytes memory data) public override {
        transfer(recipient, amount);
        require(_checkOnKIP7Received(msg.sender, recipient, amount, data), "KIP7: transfer to non KIP7Receiver implementer");
    }

    function safeTransfer(address recipient, uint256 amount) public override {
        safeTransfer(recipient, amount, "");
    }

    function safeTransferFrom(address sender, address recipient, uint256 amount, bytes memory data) public override {
        transferFrom(sender, recipient, amount);
        require(_checkOnKIP7Received(sender, recipient, amount, data), "KIP7: transfer to non KIP7Receiver implementer");
    }

    function safeTransferFrom(address sender, address recipient, uint256 amount) public override {
        safeTransferFrom(sender, recipient, amount, "");
    }

    function _checkOnKIP7Received(address sender, address recipient, uint256 amount, bytes memory _data)
        internal returns (bool)
    {
        if (!recipient.isContract()) {
            return true;
        }

        bytes4 retval = IKIP7Receiver(recipient).onKIP7Received(msg.sender, sender, amount, _data);
        return (retval == _KIP7_RECEIVED);
    }
}
