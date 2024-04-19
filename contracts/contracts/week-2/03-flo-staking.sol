// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./02-flo-reward.sol";
import "./01-flo-nft.sol";

contract FloStaking is IERC721Receiver {
    FloReward public token;
    FloNft public nftToken;

    uint256 public totalStaked;

    uint256 public constant WITHDRAWAL_INTERVAL = 24 hours;
    uint256 public constant REWARD_AMOUNT_PER_24H = 10 * (10 ** 18); // 10 ERC20 tokens

    event NFTStaked(address owner, uint256 tokenId);
    event NFTUnstaked(address owner, uint256 tokenId);
    event Claimed(address owner, uint256 amount);

    struct Stake {
        uint256 tokenId;
        address originalOwner;
        uint256 timestamp;
    }

    // maps tokenId to stake
    mapping(uint256 tokenId => Stake stake) public stakes;

    constructor(address _tokenAddress, address _nftTokenAddress) {
        token = FloReward(_tokenAddress);
        nftToken = FloNft(_nftTokenAddress);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        // Check only NFT token address can call this contract
        require(msg.sender == address(nftToken), "Wrong NFT");
        // This doesn't work
        // require(from == address(0x0), "Cannot send nfts to Vault directly");

        // This doesn't work as msg.sender is the NFT contract address and not the wallet owning the NFT
        // require(nftToken.ownerOf(tokenId) == msg.sender, "not your token");
        require(stakes[tokenId].tokenId == 0, "already staked");

        stakes[tokenId] = Stake({
            tokenId: tokenId,
            originalOwner: from, // wrong as this would be the NFT address
            timestamp: block.timestamp
        });

        emit NFTStaked(from, tokenId);

        return IERC721Receiver.onERC721Received.selector;
    }

    function unstakeNft(uint256 tokenId) external {
        address originalOwner = stakes[tokenId].originalOwner;

        require((msg.sender) == originalOwner, "Not the original owner");
        delete stakes[tokenId];
        nftToken.transferFrom(address(this), msg.sender, tokenId);

        emit NFTUnstaked(msg.sender, tokenId);
    }

    function claimReward(uint256 tokenId, bytes32[] memory proof) external {
        // retrieve the stake based on the tokenId
        Stake memory stake = stakes[tokenId];

        // make sure the claimer is owning the NFT
        require(
            stake.originalOwner == msg.sender,
            "Not the owner of the NFT for the claim"
        );

        uint256 interval = (block.timestamp - stake.timestamp) / 60 / 60; // in hours

        // make sure it's been at least 24h since the last claim
        require(interval >= WITHDRAWAL_INTERVAL, "Must claim after 24h");

        uint256 earned = REWARD_AMOUNT_PER_24H * (interval / 24);

        if (earned > 0) {
            nftToken.safeMint(msg.sender, proof);

            emit Claimed(msg.sender, earned);
        }
    }
}
