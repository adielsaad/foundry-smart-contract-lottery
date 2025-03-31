// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {IVRFCoordinatorV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/** @title Raffle contract
 * @author Adiel Saad
 * @notice This contract is for creating a simple raffle
 * @dev This implements Chainlink VRF to select a random winner
 */

contract Raffle is VRFConsumerBaseV2Plus {
    /* Errors */
    error Raffle__NotEnoughEthSent();

    /* Chainlink VRF Variables */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint32 private immutable i_callbackGasLimit;
    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subscriptionId;
    /* State variables */   
    uint256 private immutable i_entranceFee;
    // @dev The duration of the raffle in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    bytes32 private s_keyHash;

    uint32 private s_callbackGasLimit;


    /* Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator, bytes32 keyHash, uint64 subscriptionId, uint32 callbackGasLimit) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_callbackGasLimit = callbackGasLimit;
        i_keyHash = keyHash;
        i_subscriptionId = subscriptionId;
        s_lastTimeStamp = block.timestamp;
        s_vrfCoordinator = IVRFCoordinatorV2Plus(vrfCoordinator);
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }   

    // 1. Get a random number
    // 2. Use the VRF Coordinator to fulfill the request
    // 3. Pick a winner
    // 4. Send the money to the winner
    function pickWinner() external {
        // check to see if the interval has passed
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash,
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFIRMATIONS,
            callbackGasLimit: i_callbackGasLimit,
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(
                VRFV2PlusClient.ExtraArgsV1({
                    nativePayment: false
                })
            )
        });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
        // emit RequestedRaffleWinner(requestId);
    }


    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_lastTimeStamp = block.timestamp;
        s_players = new address payable[](0);
        (bool success, ) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert();
        }
    }
    /** Getter functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }


}