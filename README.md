# SSV DKG

> SSV with RockX DKG support

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/consensusnetworks/ssv-dkg.git
    ```

2. Pull submodules:

    ```bash
    make pull_submodules
    ```

3. Create a `.env` file:

    ```bash
    touch .env
    ```

4. Configure your required services:

    1. Configure a single node:

        1. Set the `SERVICES` variable in your `.env` to a single node:

            ```bash
            echo "SERVICES=node" >> .env
            ```

        2. Copy the example config files:

            ```bash
            make copy_example_files
            ```

        3. Generate new operator keys:

            ```bash
            make generate_operator_keys
            ```

        4. Fill in the `OperatorPrivateKey` in `./config/ssv.node.yaml`.

        5. Fill in the `OPERATOR_PRIVATE_KEY` in `./env/dkg.node.env`.
  
        6. Update the `eth1.ETH1Addr` in `./config/ssv.node.yaml` to point to the correct eth1 node.

        7. Update the `eth2.BeaconNodeAddr` in `./config/ssv.node.yaml` to point to the correct beacon node.

    2. Run multiple nodes:

        1. Set the `SERVICES` variable in your `.env` to multiple nodes (max 8):

            ```bash
            echo "SERVICES=node.1,node.2,node.3,node.4" >> .env
            ```

        2. Copy the example config files:

            ```bash
            make copy_example_files
            ```

        3. For each node (number represented with `n`):

            1. Generate new operator keys:

               ```bash
               make generate_operator_keys
               ```

            2. Fill in the `OperatorPrivateKey` in `./config/ssv.node.n.yaml`.

            3. Fill in the `OPERATOR_PRIVATE_KEY` in `./env/dkg.node.n.env`.

            4. Update the `eth1.ETH1Addr` in `./config/ssv.node.n.yaml` to point to the correct eth1 node.

            5. Update the `eth2.BeaconNodeAddr` in `./config/ssv.node.n.yaml` to point to the correct beacon node.

    3. Configure an exporter node:

        1. Set the `SERVICES` variable in your `.env` to the exporter node:

            ```bash
            echo "SERVICES=exporter" >> .env
            ```

        2. Copy the example config files:

            ```bash
            make copy_example_files
            ```

        3. Update the `eth1.ETH1Addr` in `./config/ssv.exporter.yaml` to point to the correct execution node RPC URL.

        4. Update the `eth2.BeaconNodeAddr` in `./config/ssv.exporter.yaml` to point to the correct consensus node RPC URL.

    4. Configure a messenger server:

        1. Set the `SERVICES` variable in your `.env` to the messenger server:

            ```bash
            echo "SERVICES=messenger" >> .env
            ```

        2. Copy the example config files:

            ```bash
            make copy_example_files
            ```

    5. Configure multiple services:

        1. Set the `SERVICES` variable in your `.env` to multiple services:

            ```bash
            echo "SERVICES=node.1,node.2,node.3,node.4,exporter,messenger" >> .env
            ```

        2. Copy the example config files:

            ```bash
            make copy_example_files
            ```

        3. Follow the specific file configuration steps for each service (skip steps 1 and 2).

5. Run your required services with docker-compose:

    ```bash
    make run
    ```

6. Stop all running services:

    ```bash
    make stop
    ```
