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

3. Copy example files:

    ```bash
    make copy_example_files
    ```

4. For each operator (1-8, represented by `n`):

    1. Generate new operator keys:

        ```bash
        make generate_operator_keys
        ```

    2. Fill in the `OperatorPrivateKey` in `./config/ssv.node.n.yaml`.

    3. Create a new keystore:

        ```bash
        make generate_keystore
        ```

    4. Fill in the `KEYSTORE_FULL_PATH`, `KEYSTORE_PASSWORD`, and `OPERATOR_PRIVATE_KEY` in `./env/dkg.node.n.env`.

5. Run your required services (pick one of the following):

    1. Run all services:

        ```bash
        make run_all
        ```

    2. Run a node (node 1):

        ```bash
        make run_node
        ```

    3. Run an exporter:

        ```bash
        make run_exporter
        ```

    4. Run a messenger:

        ```bash
        make run_messenger
        ```

6. Update your required services by rerunning your command from above.

7. Stop your services:

    1. Stop all services:

        ```bash
        make stop_all
        ```

    2. Stop a node (node 1):

        ```bash
        make stop_node
        ```

    3. Stop an exporter:

        ```bash
        make stop_exporter
        ```

    4. Stop a messenger:

        ```bash
        make stop_messenger
        ```
