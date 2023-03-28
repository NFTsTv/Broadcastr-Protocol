// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin-upgradeables/contracts/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin-upgradeables/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin-upgradeables/contracts/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

error MintPriceNotPaid(string message);
error NonExistentTokenURI(string message);
error WithdrawTransfer(string message);

contract Castr is Initializable, ERC721Upgradeable, OwnableUpgradeable {
    uint128 public currentTokenId;

    string public CastrName;
    string public baseTokenURI;
    string public description;
    bool public limitedSupply;
    uint128 public totalSupply;
    uint16 public mintPrice;
    uint public nextLivestreamDateTime;                     // expressed in seconds since 1 Jan 1970 at 00:00:00

    string[] public tags;

    event MetadataUpdated(
        string baseTokenURI, string name, string description, bool limitedSupply, uint128 totalSupply, uint16 mintPrice
    );
    event TokenMinted(address indexed recipient, uint128 tokenId);

    function initialize(
        string calldata _baseTokenURI,
        string calldata _name,
        string calldata _description,
        bool _limitedSupply,
        uint128 _totalSupply,
        uint16 _mintPrice
    )
        external
    {
        baseTokenURI = _baseTokenURI;
        CastrName = _name;
        description = _description;
        limitedSupply = _limitedSupply;
        totalSupply = _totalSupply;
        mintPrice = _mintPrice;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) {
            revert NonExistentTokenURI("Token URI does not exist");
        }
        return baseTokenURI;
    }

    function setTokenURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
        emit MetadataUpdated(baseTokenURI, CastrName, description, limitedSupply, totalSupply, mintPrice);
    }

    function setName(string memory _name) public onlyOwner {
        CastrName = _name;
        emit MetadataUpdated(baseTokenURI, CastrName, description, limitedSupply, totalSupply, mintPrice);
    }

    function setDescription(string memory _description) public onlyOwner {
        description = _description;
        emit MetadataUpdated(baseTokenURI, CastrName, description, limitedSupply, totalSupply, mintPrice);
    }

    function setSubscriptionPrice(uint16 _mintPrice) public onlyOwner {
        mintPrice = _mintPrice;
        emit MetadataUpdated(baseTokenURI, CastrName, description, limitedSupply, totalSupply, mintPrice);
    }

    function setTags(string[] memory _tags) public onlyOwner {
        tags = _tags;
    }

    // @dev: This function is used to mint a new token paying the mint price or free if the caller is the owner
    // @param: recipient: address of the recipient
    // @return: newTokenId: id of the new token
    function subscribe(address recipient) public payable returns (uint128) {
        if (limitedSupply) {
            require(currentTokenId < totalSupply, "No more tokens available");
        }

        if (msg.sender == owner()) {
            uint128 newTokenId = ++currentTokenId;
            _safeMint(recipient, newTokenId);
            emit TokenMinted(recipient, newTokenId);
            return newTokenId;
        }

        if (msg.value != mintPrice) {
            revert MintPriceNotPaid("Mint price not paid");
        } else {
            uint128 newTokenId = ++currentTokenId;
            _safeMint(recipient, newTokenId);
            emit TokenMinted(recipient, newTokenId);
            return newTokenId;
        }
    }

    // @dev: This function is used to withdraw the payments from the contract
    // @param: payee: address of the payee
    // @return: void
    function withdrawPayments(address payable recipient) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx,) = recipient.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer("Transfer failed");
        }
    }

    function getMetadata()
        public
        view
        returns (string memory, string memory, string memory, bool, uint128, uint16, uint128)
    {
        return (baseTokenURI, CastrName, description, limitedSupply, totalSupply, mintPrice, currentTokenId);
    }

    function setNextLivestreamDateTime(uint DateTime) public returns (string memory)
    {
        return nextLivestreamDateTime;
    }

}
