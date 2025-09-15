// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import {UnstoppableVault} from "../src/UnstoppableVault.sol";
import {UnstoppableMonitor} from "../src/UnstoppableMonitor.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {DamnValuableToken} from "../DamnValuableToken.sol";

uint256 constant TOKENS_IN_VAULT = 1_000_000e18;
uint256 constant INITIAL_PLAYER_TOKEN_BALANCE = 10e18;

contract DeployUnstoppableVaultAndMonitor is Script {
    function run() external {
        vm.startBroadcast(); 

        DamnValuableToken token = new DamnValuableToken();
        console.log("DamnValuableToken deployed at:", address(token));

        address owner = msg.sender;
        address feeRecipient = msg.sender;

        UnstoppableVault vault = new UnstoppableVault(token, owner, feeRecipient);
        console.log("UnstoppableVault deployed at:", address(vault));

        token.approve(address(vault), TOKENS_IN_VAULT);
        vault.deposit(TOKENS_IN_VAULT, address(owner));

        // Fund player's account with initial token balance
        token.transfer(0x4C1f023A2A914d109bEa600aB518f3078466e279, INITIAL_PLAYER_TOKEN_BALANCE);

        UnstoppableMonitor monitor = new UnstoppableMonitor(address(vault));
        console.log("UnstoppableMonitor deployed at:", address(monitor));
        vault.transferOwnership(address(monitor));

        vm.stopBroadcast();
    }
}