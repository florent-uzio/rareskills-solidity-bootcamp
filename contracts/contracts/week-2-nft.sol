// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Week2Nft is ERC721, ERC2981, Ownable {
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
    ) public view virtual override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
