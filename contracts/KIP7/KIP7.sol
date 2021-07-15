// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../interfaces/IKIP7Receiver.sol";
import "../interfaces/IKIP7.sol";
import "../KIP13/KIP13.sol";

abstract contract KIP7 is KIP13, IKIP7 {
    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    bytes4 private constant _INTERFACE_ID_KIP7 = type(IKIP7).interfaceId;

    constructor () {
        _registerInterface(_INTERFACE_ID_KIP7);
    }

    function _transfer(address from, address to, uint256 value)
        internal
        returns (bool success)
    {
        _balances[from] = _balances[from] - value;
        _balances[to] = _balances[to] + value;
        emit Transfer(from, to, value);
        success = true;
    }

    function _approve(address owner, address spender, uint256 value)
        internal
        returns (bool success)
    {
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
        success = true;
    }

    function _mint(address _to, uint256 _amount)
        internal
        returns (bool success)
    {
        _totalSupply = _totalSupply + _amount;
        _balances[_to] = _balances[_to] + _amount;
        emit Transfer(address(0), _to, _amount);
        success = true;
    }

    /*
   * public view functions to view common data
   */

    function totalSupply() external override view returns (uint256 total) {
        total = _totalSupply;
    }
    function balanceOf(address account) external override view returns (uint256 balance) {
        balance = _balances[account];
    }

    function allowance(address owner, address spender)
        external
        override
        view
        returns (uint256 remaining)
    {
        remaining = _allowances[owner][spender];
    }
}
