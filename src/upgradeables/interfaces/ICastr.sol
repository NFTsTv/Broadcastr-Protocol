// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICastr {
    event MetadataUpdated(
        string baseTokenURI, string name, string description, bool limitedSupply, uint256 totalSupply, uint256 mintPrice
    );
    event TokenMinted(address indexed recipient, uint256 tokenId);

    function tokenURI(uint256 tokenId) external view returns (string memory);
    function setTokenURI(string calldata _baseTokenURI) external;
    function setName(string calldata _name) external;
    function setDescription(string calldata _description) external;
    function setSubscriptionPrice(uint256 _mintPrice) external;
    function setTags(string[] calldata _tags) external;
    function subscribe(address recipient) external payable returns (uint256);
    function withdrawPayments(address payable recipient) external;
    function getMetadata()
        external
        view
        returns (string memory, string memory, string memory, bool, uint256, uint256, uint256);
}
