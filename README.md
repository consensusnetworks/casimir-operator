# SSV DKG

SSV operator node with RockX DKG support

## Usage

1. Clone the repository and submodules:

```bash
git clone --recursive https://github.com/consensusnetworks/ssv-dkg.git
```

2. Install prerequisites and copy templates:

```bash
./install.sh && cp example.env .env && cp example.config.yaml config.yaml
```

3. Generate operator keys:

```bash
docker run -d --name=ssv_node_op_key -it 'bloxstaking/ssv-node:latest' \
/go/bin/ssvnode generate-operator-keys && docker logs ssv_node_op_key --follow \
&& docker stop ssv_node_op_key && docker rm ssv_node_op_key
```

4. Replace any bracketed value descriptions (`somevar=<your-value-here>`) with your values in [.env](.env) and [config.yaml](config.yaml).

5. Create a new keystore:

```bash
mkdir keys
clef newaccount --keystore keys
```

6. Start the node:

```bash
docker compose -p ssv-dkg-1 up -d
```
