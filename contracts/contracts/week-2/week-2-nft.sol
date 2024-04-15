// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract Week2Nft is ERC721Royalty, Ownable {
    // bytes32 = [byte, byte, ..., byte] <- 32 bytes
    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _addressesList;

    uint16 public constant MAX_MINT = 1000;
    uint256 private _nextTokenId;

    constructor(
        address initialOwner,
        bytes32 _merkleRoot
    ) ERC721("Week2Nft", "W2N") Ownable(initialOwner) {
        merkleRoot = _merkleRoot;
        // 2.5% royalty for all NFTs sent to the initialOwner
        super._setDefaultRoyalty(initialOwner, 2500);
    }

    function safeMint(address to, bytes32[] memory proof) public {
        // removed onlyOwner to allow anyone to potentially mint if they are in the allowlist
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

        // Check if address part of whitelist
        require(isValid(proof, leaf), "Not in whitelist");

        // Check maximum of 1000 NFT minted
        require(_nextTokenId < MAX_MINT, "Max supply reached");

        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721Royalty) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function isValid(
        bytes32[] memory proof,
        bytes32 leaf
    )
        public
        view
        returns (
            // uint256 index,
            // uint256 amount,
            // address addr
            bool
        )
    {
        // bytes32 leaf = keccak256(
        //     bytes.concat(keccak256(abi.encode(addr, index, amount)))
        // );
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
}
