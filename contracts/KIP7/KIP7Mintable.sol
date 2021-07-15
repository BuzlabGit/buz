// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./KIP7.sol";
import "../library/KIP7Pausable.sol";

abstract contract KIP7Mintable is KIP7, KIP7Pausable {
    event Mint(address indexed _to, uint256 _amount);
    event MintFinished();
    uint256 internal _cap;

    bool internal _mintingFinished;
    ///@notice mint token
    ///@dev only owner can call this function
    function mint(address _to, uint256 _amount)
        external
        onlyOwner
        whenNotPaused
        returns (bool success)
    {
        require(
            _to != address(0),
            "KIP7Mintable/mint : Should not mint to zero address"
        );
        require(
            _totalSupply + _amount <= _cap,
            "KIP7Mintable/mint : Cannot mint over cap"
        );
        require(
            !_mintingFinished,
            "KIP7Mintable/mint : Cannot mint after finished"
        );
        _mint(_to, _amount);
        emit Mint(_to, _amount);
        success = true;
    }

    ///@notice finish minting, cannot mint after calling this function
    ///@dev only owner can call this function
    function finishMint()
        external
        onlyOwner
        returns (bool success)
    {
        require(
            !_mintingFinished,
            "KIP7Mintable/finishMinting : Already finished"
        );
        _mintingFinished = true;
        emit MintFinished();
        return true;
    }

    function cap()
        external
        view
        returns (uint256)
    {
        return _cap;
    }

    function isFinished() external view returns(bool finished) {
        finished = _mintingFinished;
    }
}
