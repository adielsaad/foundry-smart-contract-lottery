# Foundry Smart Contract Lottery

A decentralized lottery system built with Solidity and Foundry, implementing Chainlink VRF for secure random number generation.

## Features

- Decentralized lottery system
- Chainlink VRF integration for secure random number generation
- Configurable entrance fee and time intervals
- Automated winner selection and payment
- Gas-optimized contract design

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Solidity ^0.8.19
- Chainlink VRF v2

## Installation

1. Clone the repository:
```bash
git clone https://github.com/adiel/foundry-smart-contract-lottery.git
cd foundry-smart-contract-lottery
```

2. Install dependencies:
```bash
forge install
```

## Contract Details

### Raffle.sol

The main contract that handles:
- Player registration
- Random winner selection using Chainlink VRF
- Prize distribution
- Time-based raffle rounds

#### Key Functions

- `enterRaffle()`: Allows players to enter the raffle by paying the entrance fee
- `pickWinner()`: Initiates the winner selection process using Chainlink VRF
- `fulfillRandomWords()`: Callback function that processes the random number and selects the winner

## Testing

Run the test suite:
```bash
forge test
```

## Deployment

1. Configure your environment variables
2. Deploy using Foundry:
```bash
forge create src/Raffle.sol:Raffle --rpc-url <your-rpc-url> --private-key <your-private-key>
```


