# Casimir Operator

> SSV operator with DKG server

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/consensusnetworks/ssv-dkg.git
    ```

2. Install submodules:

    ```bash
    make install
    ```

3. Create a `.env` file:

    ```bash
    touch .env
    ```

4. Configure your required services:

    1. Configure a **single node**:

        1. Set `SERVICES=node` in your `.env` file.

        2. Copy the example config files:

            ```bash
            make copy
            ```

        3. Generate new operator keys:

            ```bash
            make generate_operator_keys
            ```

        4. Create a file `./keys/sk.txt` and fill it with the operator private key.

        5. Fill in the `OperatorPrivateKey` in `./config/ssv.node.yaml`.

        6. Update the `eth1.ETH1Addr` in `./config/ssv.node.yaml` to point to the correct eth1 node.

        7. Update the `eth2.BeaconNodeAddr` in `./config/ssv.node.yaml` to point to the correct beacon node.

        8. Copy the operator public key and [register it with SSV network](https://docs.ssv.network/run-a-node/operator-node/registration) to get an operator ID.

    2. Configure **multiple nodes**:

        1. Set `SERVICES=node.1,node.2,node.3,node.4` in your `.env` file, or include as many nodes as you want up to 8.

        2. Copy the example config files:

            ```bash
            make copy
            ```

        3. For each node (number represented with `{n}`):

            1. Generate new operator keys:

               ```bash
               make generate_operator_keys
               ```

            2. Create a file `./keys/sk.{n}.txt` and fill it with the operator private key.

            3. Fill in the `OperatorPrivateKey` in `./config/ssv.node.{n}.yaml`.

            4. Update the `eth1.ETH1Addr` in `./config/ssv.node.{n}.yaml` to point to the correct eth1 node.

            5. Update the `eth2.BeaconNodeAddr` in `./config/ssv.node.{n}.yaml` to point to the correct beacon node.

            6. Copy the operator public key and [register it with SSV network](https://docs.ssv.network/run-a-node/operator-node/registration) to get an operator ID.

    3. Configure an **exporter node**:

        1. Set `SERVICES=exporter` in your `.env` file.

        2. Copy the example config files:

            ```bash
            make copy
            ```

        3. Update the `eth1.ETH1Addr` in `./config/ssv.exporter.yaml` to point to the correct execution node RPC URL.

        4. Update the `eth2.BeaconNodeAddr` in `./config/ssv.exporter.yaml` to point to the correct consensus node RPC URL.

    4. Configure **multiple services**:

        1. Set `SERVICES=node.1,node.2,node.3,node.4,exporter` in your `.env` file, or include as many nodes as you want up to 8.

            ```bash
            echo "SERVICES=node.1,node.2,node.3,node.4,exporter" >> .env
            ```

        2. Copy the example config files:

            ```bash
            make copy
            ```

        3. Follow the specific file configuration steps for each service (skip steps 1 and 2).

5. Run your required services with docker-compose:

    ```bash
    make up
    ```

6. Stop all running services:

    ```bash
    make down
    ```
