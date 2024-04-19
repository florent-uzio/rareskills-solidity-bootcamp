// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./04-enumerable.sol";

contract PrimeCount {
    Enumerable public nftContract;

    constructor(address _enumerable) {
        nftContract = Enumerable(_enumerable);
    }

    function isPrime(uint256 number) internal pure returns (bool) {
        if (number <= 1) {
            return false;
        }
        for (uint256 i = 2; i * i <= number; i++) {
            if (number % i == 0) {
                return false;
            }
        }
        return true;
    }

    function countPrimesOwned(address owner) external view returns (uint256) {
        uint256 totalTokens = nftContract.balanceOf(owner);
        uint256 primeCount = 0;

        for (uint256 i = 0; i < totalTokens; i++) {
            uint256 tokenId = nftContract.tokenOfOwnerByIndex(owner, i);
            if (isPrime(tokenId)) {
                primeCount++;
            }
        }

        return primeCount;
    }
}
