// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SoccerNft is ERC721URIStorage {
    uint256 private _tokenIds;
    address private _baseTokenURI;

    constructor() ERC721("MyNFT", "NFT") {}

    function mintNFT(string memory tokenURI, address mintnft) external returns (uint256) {
        _tokenIds++;
        uint256 newItemId = _tokenIds;

        _mint(mintnft, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "";
    }
}