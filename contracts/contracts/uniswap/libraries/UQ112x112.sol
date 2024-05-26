// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

library UQ112x112 {
    uint8 private constant RESOLUTION = 112; // 20 decimal places
    uint256 private constant Q = uint256(1) << RESOLUTION;

    function encodeFixedPoint(uint256 x) internal pure returns (uint256) {
        return x * Q;
    }

    function decodeFixedPoint(uint256 x) internal pure returns (uint256) {
        return x / Q;
    }

    function multiplyFixedPoint(
        uint256 x,
        uint256 y
    ) internal pure returns (uint256) {
        return (x * y) / Q;
    }

    function divideFixedPoint(
        uint256 x,
        uint256 y
    ) internal pure returns (uint256) {
        return (x * Q) / y;
    }
}
