// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICastrFactory {
    event CastrCreated(address indexed castr, address indexed creator);

    function createCastr(
        string calldata _baseTokenURI,
        string calldata _name,
        string calldata _description,
        bool _limitedSupply,
        uint256 _totalSupply,
        uint256 _mintPrice
    )
        external
        returns (address);

    function getBeacon() external view returns (address);
}
