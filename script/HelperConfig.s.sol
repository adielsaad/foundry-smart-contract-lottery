// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";

abstract contract CodeConstants { 
    /* VRF Coordinator Mock */
    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    /* Chain IDs */
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        uint256 subscriptionId;
        address link;
        address account;
    }

    NetworkConfig public localNetworkConfig;
    mapping(uint256 => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether, 
            interval: 30 seconds,
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit: 500000,
            // TODO: Replace with your subscription ID after creating one
            // You can create a subscription using the CreateSubscription script
            subscriptionId: 0,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            account: 0xc0Bf06cE338FCFe868b9c43DA99a7C496892a15d
        });
    }
    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if( networkConfigs[chainId].vrfCoordinator != address(0)) {
            return networkConfigs[chainId];
        }
        else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        }
        else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // if the config is already set, return it
        if( networkConfigs[LOCAL_CHAIN_ID].vrfCoordinator != address(0) ) {
            return localNetworkConfig;
        }
        
        // Deploy the mock
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinator = new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK, MOCK_WEI_PER_UNIT_LINK);
        LinkToken linkToken = new LinkToken();
        vm.stopBroadcast();

        // Return the config
       localNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether, 
            interval: 30 seconds,
            vrfCoordinator: address(vrfCoordinator),
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            callbackGasLimit: 500000,
            subscriptionId: 0,
            link: address(linkToken),
            account: msg.sender
        });
        return localNetworkConfig;
    }
}   

contract AddConsumer is Script {
    function addConsumer(address vrfCoordinator, uint256 subscriptionId) public {
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subscriptionId, msg.sender);
        vm.stopBroadcast();
    }
}