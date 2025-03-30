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

/** @title Raffle contract
 * @author Adiel Saad
 * @notice This contract is for creating a simple raffle
 * @dev This implements Chainlink VRF to select a random winner
 */
contract Raffle {
    /* Errors */
    error Raffle__NotEnoughEthSent();

    /* State variables */   
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    /* Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }   
    function pickWinner() public {
    }

    /** Getter functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}