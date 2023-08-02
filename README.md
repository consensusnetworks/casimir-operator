# SSV DKG

SSV operator node with RockX DKG support

## Usage

1. Copy templates:

```bash
cp example.env .env && cp example.config.yaml config.yaml
```

2. Replace any bracketed value descriptions (`somevar=<your-value-here>`) with your values in [.env](.env) and [config.yaml](config.yaml).

3. Create a new keystore:

```bash
mkdir keys
clef newaccount --keystore keys
```

3. Start and follow the node:

```bash
docker run -d --network=host --restart unless-stopped --name=ssv-dkg-1 -e CONFIG_PATH=./config.yaml -p 13002:13002 -p 12002:12002/udp -v $(pwd)/config.yaml:/config.yaml -v $(pwd):/data -it 'bloxstaking/ssv-node:latest' make BUILD_PATH=/go/bin/ssvnode start-node && docker logs ssv-dkg-1 --follow
```
