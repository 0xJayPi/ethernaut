// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level18.sol";
import "forge-std/Script.sol";

contract ExploitLevel18 is Script {
    MagicNum instance = MagicNum(0x9997d552B662f666372EA436F4D6086652cd3474);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes memory finalCode = "x60x0ax60x0cx60x00x39x60x0ax60x00xf3x60x2ax60x80x52x60x20x60x80xf3";
        address solverAddr;

        assembly {
            solverAddr := create(0, add(finalCode, 0x20), mload(finalCode))
        }
        instance.setSolver(solverAddr);

        vm.stopBroadcast();
    }
}
