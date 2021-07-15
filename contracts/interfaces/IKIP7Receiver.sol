// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

abstract contract IKIP7Receiver {
    function onKIP7Received(address _operator, address _from, uint256 _amount, bytes memory _data) external virtual returns (bytes4);
}