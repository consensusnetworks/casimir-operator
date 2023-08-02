# SSV DKG

SSV operator node with RockX DKG support

## Usage

1. Clone the repository and submodules:

```bash
git clone --recursive https://github.com/consensusnetworks/ssv-dkg.git
```

2. Install prerequisites and copy templates:

```bash
./install.sh && cp example.env .env && cp example.config.yaml config.yaml && cp messenger/example.env messenger/.env
```

3. Generate operator keys:

```bash
docker run -d --name=ssv_node_op_key -it 'bloxstaking/ssv-node:latest' \
/go/bin/ssvnode generate-operator-keys && docker logs ssv_node_op_key --follow \
&& docker stop ssv_node_op_key && docker rm ssv_node_op_key
```

4. Replace any bracketed value descriptions (`somevar=<your-value-here>`) with your values in [.env](.env), [config.yaml](config.yaml), and [messenger/.env](messenger/.env).

5. Create a new keystore:

```bash
mkdir keys
clef newaccount --keystore keys
```

6. Start the node:

```bash
docker compose -p ssv-dkg-1 up -d
```

7. Start the messenger (if a messenger is not running already):

```bash
docker compose -f messenger/docker-compose.yaml -p ssv-dkg-messenger up -d
```
