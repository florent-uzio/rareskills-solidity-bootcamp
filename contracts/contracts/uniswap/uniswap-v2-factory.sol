// SPDX-License-Identifier: MIT

import "./interfaces/uniswap-v2-factory.sol";
import "./uniswap-v2-pair.sol";

pragma solidity ^0.8.20;

contract UniswapV2Factory is IUniswapV2Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair) {
        // make sure we have a pair of two different tokens
        require(tokenA != tokenB, "UniswapV2: identical pair addresses");

        // ordering tokens based on the hexadecimal values of the addresses.
        // used to impose a consistent ordering when dealing with pairs of tokens, such as in Uniswap contracts.
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);

        require(token0 != address(0), "UniswapV2: ZERO_ADDRESS");

        /**
         * == address(0) checks if the retrieved address is the zero address. In Ethereum, the zero address represents an uninitialized address or a non-existent contract.
         * This single check is sufficient
         */
        require(
            getPair[token0][token1] == address(0),
            "UniswapV2: PAIR_EXISTS"
        );

        bytes memory bytecode = type(UniswapV2Pair).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        // Create an address
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        // TODO: Check with instructor why we use the interface IUniswapV2Pair and not UniswapV2Pair
        IUniswapV2Pair(pair).initialize(token0, token1);

        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    // TODO: Check with instructor
    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeTo = _feeTo;
    }

    // TODO: Check with instructor
    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
