# Feet2Walk

Experiment on self balancing tokens.

⚙️ Built using 🏗 Scaffold-ETH 2, NextJS, RainbowKit, Hardhat, Wagmi, Viem, and Typescript.

## Features

It has 3 contracts, a token $FEET, a Walk NFT, and a FeetCoordinator

1. Token $FEET: The mint price increases exponentially with supply initially and then flattens out as it reaches higher prices. This mechanism encourages early adoption while preventing rapid inflation as the token price increases.

2. Walk NFT minting: Minted by paying with 2 $FEET tokens.

- **Benefits of a fixed price of 2 $FEET**: Simplicity and predictability for users, ensuring a consistent cost for minting Walk NFTs.
- **Risks of a fixed price**: Potential lack of flexibility in adjusting minting costs based on market conditions or token price fluctuations.

3. Walk NFT "step" counting and display: Walk NFTs start counting blocks (steps) since minting and display the step count on the token image (Dynamic SVG).

4. Walk NFT burn Functionality: Walk NFTs can be burnt to decrease the $FEET token price.

- The decreasing power of Walk NFTs increases based on the number of steps counted since minting.

5. FeetCoordinator Contract: Acts as the owner of both tokens and handles minting, burning, and ETH withdrawals by the owner.

6. FeetCoordinator endWalkAndBuyTokens function: Function to prevent front-running when burning to purchase cheaper tokens. This function enhances the security and fairness of the token ecosystem.

## Economic variables

- $FEET token price: Exponentially increasing at first, flattening out later.
- Walk NFT price: 2 $FEET (it just takes to $FEET to go for a Walk)
- Walk NFT decreasing power: Increasing by less at first, and more later, to encourage holding.

## Original idea notes

- Use the DEX lesson curve to display how much burning a Walk NFT would affect the $FEET token price?

## Requirements

Before you begin, you need to install the following tools:

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started, follow the steps below:

1. Clone this repo & install dependencies

```
git clone https://github.com/luloxi/Feet2Walk.git
cd Feet2Walk
yarn install
```

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `hardhat.config.ts`.

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in `packages/hardhat/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/hardhat/deploy` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.
