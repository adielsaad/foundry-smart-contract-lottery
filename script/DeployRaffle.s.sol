// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "script/Interactions.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        return deployContract();
    }

    function deployContract() public returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!
        // Add the contract as a consumer to the VRF coordinator
        AddConsumer addConsumer = new AddConsumer();
        // Sepolia -> get the sepolia config
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        if (config.subscriptionId == 0) {
            // Create a subscription
            CreateSubscription createSubscription = new CreateSubscription();
            (config.subscriptionId, config.vrfCoordinator) = createSubscription.createSubscription(config.vrfCoordinator, config.account);
            // Fund the subscription
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(config.vrfCoordinator, config.subscriptionId, config.link, config.account);
        }
        vm.startBroadcast(config.account);
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );
        
        vm.stopBroadcast(); 
        
        // Don't need to broadcast this because it's already broadcasted in the Interactions.s.sol file
        addConsumer.addConsumer(address(raffle), config.vrfCoordinator, config.subscriptionId, config.account);
 

        return (raffle, helperConfig);
    }
}