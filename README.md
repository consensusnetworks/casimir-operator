# Casimir Operator

> SSV operator with DKG server

## Setup

Casimir operators are required to run an SSV node to perform duties for validators. Since validator keys are created and reshared using distributed key generation (DKG), operators must also run a DKG server to participate in key ceremonies. A Casimir operator consists of the following components:

1. The [Ethereum RPC node](#ethereum-rpc-node) connects the SSV DVT node to the Ethereum network.
2. The [SSV node](#ssv-node) performs cluster duties for validators.
3. The [SSV DKG server](#ssv-dkg-server) participates in key generation and resharing ceremonies.

### Quickstart

Complete the following steps to quickly start a Casimir operator:

1. Clone the Casimir Operator repository:
    ```bash
    git clone https://github.com/consensusnetworks/casimir-operator.git && cd casimir-operator
    ```
2. Install submodules:
    ```bash
    make install
    ```
3. Copy the required config files:
    ```bash
    make copy
    ```
4. Update the `eth1.ETH1Addr` in `./config/ssv.node.yaml` to point to the correct eth1 node.
5. Update the `eth2.BeaconNodeAddr` in `./config/ssv.node.yaml` to point to the correct beacon node.
6. Generate new operator keys (you will be prompted for a keystore password):
    ```bash
    make generate_operator_keys
    ```
7. Copy the operator public key from `./keys/encrypted.json` and [register it with SSV network](https://docs.ssv.network/run-a-node/operator-node/registration) to get an operator ID.
8. Run your node with docker-compose:
    ```bash
    make up
    ```
9. Stop your node:
    ```bash
    make down
    ```

### Assemble Your Own

If you'd like to assemble your own Casimir operator stack, take note of the requirements for each component below.

#### Ethereum RPC Node

You can use any pair of execution and consensus client to run your Ethereum RPC node. See the list of [execution](https://ethereum.org/en/developers/docs/nodes-and-clients/#execution-clients) and [consensus](https://ethereum.org/en/developers/docs/nodes-and-clients/#consensus-clients) clients to choose the best pair for your system, then follow the respective client docs to set up your node. We also recommend [ETH Docker](https://github.com/eth-educators/eth-docker) to easily set up and run both clients in a single stack. **The execution and consensus RPC APIs must be enabled and accessible to the SSV node.**

#### SSV Node

The [SSV node installation guide](https://docs.ssv.network/operator-user-guides/operator-node/installation) walks through preparing the required services, securely generating an operator keystore, and configuring the node. Note, you can also use [ETH Docker's SSV support](https://eth-docker.net/Support/SSV) to combine your Ethereum RPC node and SSV node into a single stack.

#### SSV DKG Server

You can follow the [SSV DKG server installation guide](https://github.com/bloxapp/ssv-dkg#operator-quick-start) to add a DKG server to your operator. The DKG server configuration will also require your encrypted operator keystore and password file paths. **You must provide a publicly accessible DKG node endpoint to Casimir during registration.**

### Development

Assuming you have already cloned the repository and installed submodules, you can run the following commands to start a Casimir operator:

1. Create a `.env` file:
    ```bash
    touch .env
    ```
2. Set `MODE=development` in your `.env` file.
3. Set `SERVICES=node.1,node.2,node.3,node.4` in your `.env` file, or include as many nodes as you want up to 8.
4. Copy the required config files:
    ```bash
    make copy
    ```
5. Follow steps 4-6 in the [Quickstart](#quickstart) guide for each node 1 to _n_. The copied config file names will specify the node number, e.g. `./config/ssv.node.1.yaml`. 
6. Run your required services with docker-compose:
    ```bash
    make up
    ```
7. Stop all running services:
    ```bash
    make down
    ```
