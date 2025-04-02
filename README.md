# Foundry Smart Contract Lottery

A decentralized lottery system built with Solidity and Foundry, implementing Chainlink VRF v2.5 for secure random number generation and Chainlink Automation for automated upkeep.

## Features

- Decentralized lottery system with automated winner selection
- Chainlink VRF v2.5 integration for cryptographically secure random number generation
- Chainlink Automation for automated upkeep and winner selection
- Configurable entrance fee and time intervals
- Gas-optimized contract design
- Comprehensive test suite with both local and forked environments
- Multi-chain deployment support (Local, Sepolia)

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Solidity ^0.8.19
- Chainlink VRF v2.5
- Chainlink Automation
- [Make](https://www.gnu.org/software/make/) (for deployment scripts)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/adielsaad/foundry-smart-contract-lottery.git
cd foundry-smart-contract-lottery
```

2. Install dependencies:
```bash
make install
```

## Contract Architecture

### Core Contracts

#### Raffle.sol
The main contract that handles:
- Player registration with ETH entrance fee
- Automated winner selection using Chainlink VRF v2.5
- Prize distribution
- Time-based raffle rounds
- State management (OPEN, CALCULATING)

#### Key Functions
- `enterRaffle()`: Allows players to enter the raffle by paying the entrance fee
- `performUpkeep()`: Automated function that initiates winner selection
- `fulfillRandomWords()`: VRF callback that processes random number and selects winner
- `checkUpkeep()`: Determines if upkeep is needed based on time and state

### Deployment Scripts

#### DeployRaffle.s.sol
Handles the deployment process:
- Deploys the Raffle contract
- Sets up VRF subscription
- Funds the subscription with LINK
- Adds the contract as a VRF consumer

#### HelperConfig.s.sol
Manages network-specific configurations:
- Entrance fee
- Time interval
- VRF coordinator address
- Gas lane
- Subscription ID
- LINK token address

## Testing

The project includes a comprehensive test suite:

### Unit Tests
```bash
make test
```

Test categories:
- Raffle initialization
- Player entry validation
- State management
- VRF integration
- Winner selection
- Prize distribution

### Fork Tests
Tests that run on forked networks (Sepolia) to verify:
- VRF coordinator integration
- LINK token interactions
- Subscription management

## Deployment

### Sepolia Network
```bash
make deploy-sepolia
```

Required environment variables:
- `SEPOLIA_RPC_URL`
- `KEYSTORE_SEPOLIA_ACCOUNT`
- `ETHERSCAN_API_KEY`

## Security Features

- Reentrancy protection
- State management checks
- Automated upkeep validation
- VRF request verification
- Gas optimization
- Comprehensive test coverage

## License

MIT

