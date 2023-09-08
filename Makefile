SHELL := /bin/bash
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)  # macOS
	SED_INPLACE := -i ""
else
	SED_INPLACE := -i
endif
SERVICES := $(shell grep SERVICES .env | cut -d '=' -f2)
SERVICE_LIST := $(shell echo $(SERVICES) | tr ',' '\n')

install:
	@git submodule update --init --recursive

copy:
	@for service in $(SERVICE_LIST); do \
		echo "Copying files for $$service"; \
		if [[ "$$service" == "node" ]]; then \
			cp ./config/example.ssv.node.yaml ./config/ssv.node.yaml; \
			cp ./env/example.dkg.node.env ./env/dkg.node.env; \
		elif [[ "$$service" =~ ^node\.[1-8]$$ ]]; then \
			n=$$(echo $$service | sed 's/node\.//g'); \
			cp ./config/example.ssv.node.yaml ./config/ssv.node.$$n.yaml; \
			cp ./env/example.dkg.node.env ./env/dkg.node.$$n.env; \
			sed $(SED_INPLACE) "s|./data/db/ssv-node|./data/db/ssv-node-$$n|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|16000|$$(($$((16000)) + $$n))|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|2500|$$(($$((2500)) + $$n))|g" ./env/dkg.node.$$n.env; \
		elif [[ "$$service" == "exporter" ]]; then \
			cp ./config/example.ssv.exporter.yaml ./config/ssv.exporter.yaml; \
		elif [[ "$$service" == "messenger" ]]; then \
			cp ./env/example.dkg.messenger.env ./env/dkg.messenger.env; \
		fi; \
	done; \
	rm -f docker-compose.override.yaml; \
	overrides=""; \
	if [[ ! $(SERVICES) =~ "messenger" ]]; then \
		overrides="$$overrides dkg-messenger"; \
	fi; \
	if [[ ! $(SERVICES) =~ (node,|,node) || $(SERVICES) == "node" ]]; then \
		overrides="$$overrides dkg-node"; \
	fi; \
	for n in {1..8}; do \
		if [[ ! $(SERVICES) =~ "node.$$n" ]]; then \
			overrides="$$overrides dkg-node-$$n"; \
		fi; \
	done; \
	if [[ ! -z "$$overrides" ]]; then \
		echo "version: '3.8'" > docker-compose.override.yaml; \
		echo "services:" >> docker-compose.override.yaml; \
	fi; \
	for service in $$overrides; do \
		echo "  $$service:" >> docker-compose.override.yaml; \
		echo "    env_file:" >> docker-compose.override.yaml; \
		if [[ $$service =~ "messenger" ]]; then \
			echo "      - ./env/example.dkg.messenger.env" >> docker-compose.override.yaml; \
		elif [[ $$service =~ "node" ]]; then \
			echo "      - ./env/example.dkg.node.env" >> docker-compose.override.yaml; \
		fi; \
	done; \

generate_operator_keys:
	@docker run --rm -it 'bloxstaking/ssv-node:latest' /go/bin/ssvnode generate-operator-keys

run:
	@stack=""; \
	for service in $(SERVICE_LIST); do \
		echo "Running stack for $$service"; \
		if [ $$service = "node" ]; then \
			stack="$$stack ssv-node dkg-node"; \
		elif [[ "$$service" =~ ^node\.[1-8]$$ ]]; then \
			n=$$(echo $$service | sed 's/node\.//g'); \
			stack="$$stack ssv-node-$$n dkg-node-$$n"; \
		elif [ $$service = "exporter" ]; then \
			stack="$$stack ssv-exporter"; \
		elif [ $$service = "messenger" ]; then \
			stack="$$stack dkg-messenger"; \
		fi; \
	done; \
	echo "Running stack: $$stack"; \
	docker compose up $$stack -d

stop:
	@echo "Stopping all services"; \
	docker compose down;


