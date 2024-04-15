// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Week2Nft is ERC721Royalty, Ownable {
    uint16 public constant MAX_MINT = 1000;
    uint256 private _nextTokenId;

    constructor(
        address initialOwner
    ) ERC721("Week2Nft", "W2N") Ownable(initialOwner) {}

    function safeMint(address to) public onlyOwner {
        require(_nextTokenId < MAX_MINT, "Max supply reached");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721Royalty) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
