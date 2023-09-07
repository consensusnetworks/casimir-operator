services_str := $(shell grep SERVICES .env | cut -d '=' -f2)
services := $(shell echo $(services_str) | tr ',' '\n') 

pull_submodules:
	git submodule update --init --recursive

copy_example_files:
	@for service in $(services); do \
		if [ $$service = "node" ]; then \
			cp ./config/example.ssv.node.yaml ./config/ssv.node.yaml; \
			cp ./env/example.dkg.node.env ./env/dkg.node.env; \
		elif [[ $$service =~ ^node.[0-9]+$$ ]]; then \
			n=`echo $$service | sed 's/node.//g'`; \
			cp ./config/example.ssv.node.yaml ./config/ssv.node.$$n.yaml; \
			cp ./env/example.dkg.node.env ./env/dkg.node.$$n.env; \
			sed -i '' 's/Path: .\/data\/db\/ssv-node/Path: .\/data\/db\/ssv-node-'$$n'/g' ./config/ssv.node.$$n.yaml; \
			sed -i '' 's/UdpPort: 16000/UdpPort: '$$((16000 + $$n))'/g' ./config/ssv.node.$$n.yaml; \
			sed -i '' 's/TcpPort: 17000/TcpPort: '$$((17000 + $$n))'/g' ./config/ssv.node.$$n.yaml; \
			sed -i '' 's/NODE_ADDR=0.0.0.0:2500/NODE_ADDR=0.0.0.0:'$$((2500 + $$n))'/g' ./env/dkg.node.$$n.env; \
		elif [ $$service = "exporter" ]; then \
			cp ./config/example.ssv.exporter.yaml ./config/ssv.exporter.yaml; \
		elif [ $$service = "messenger" ]; then \
			cp ./env/example.dkg.messenger.env ./env/dkg.messenger.env; \
		fi \
	done

generate_operator_keys:
	docker run --rm -it 'bloxstaking/ssv-node:latest' /go/bin/ssvnode generate-operator-keys

run:
	stack=""
	@for service in $(services); do \
		if [ $$service = "node" ]; then \
			stack="$$stack ssv-node dkg-node"; \
		elif [[ $$service =~ ^node.[0-9]+$$ ]]; then \
			n=`echo $$service | sed 's/node.//g'`; \
			stack="$$stack ssv-node-$$n dkg-node-$$n"; \
		elif [ $$service = "exporter" ]; then \
			stack="$$stack ssv-exporter"; \
		elif [ $$service = "messenger" ]; then \
			stack="$$stack dkg-messenger"; \
		fi \
	done; \
	docker compose up -d --build $$stack;

stop:
	docker compose down;



