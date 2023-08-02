# SSV DKG

SSV operator node with RockX DKG support

## Usage

1. Install prerequisites:

```bash
./install.sh
```

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

3. Start the node:

```bash
docker compose -p ssv-dkg-1 up -d
```
