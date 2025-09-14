// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import {UnstoppableVault} from "../src/UnstoppableVault.sol";
import {UnstoppableMonitor} from "../src/UnstoppableMonitor.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";

contract DeployUnstoppableVaultAndMonitor is Script {
    function run() external {
        vm.startBroadcast(); 

        DamnValuableToken token = new DamnValuableToken();
        console.log("DamnValuableToken deployed at:", address(token));

        address owner = msg.sender;
        address feeRecipient = msg.sender;

        UnstoppableVault vault = new UnstoppableVault(ERC20(address(token)), owner, feeRecipient);
        console.log("UnstoppableVault deployed at:", address(vault));

        UnstoppableMonitor monitor = new UnstoppableMonitor(address(vault));
        console.log("UnstoppableMonitor deployed at:", address(monitor));
        vault.transferOwnership(address(monitor));

        vm.stopBroadcast();
    }
}