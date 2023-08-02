# SSV

Start and follow the node:

```bash
docker run -d --network=host --restart unless-stopped --name=dkg-node-1-ssv -e CONFIG_PATH=./config.yaml -p 13002:13002 -p 12002:12002/udp -v $(pwd)/config.yaml:/config.yaml -v $(pwd):/data -it 'bloxstaking/ssv-node:latest' make BUILD_PATH=/go/bin/ssvnode start-node && docker logs dkg-node-1-ssv --follow
```
