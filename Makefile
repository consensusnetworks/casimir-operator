-include .env
SHELL := /bin/bash
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	SED_INPLACE := -i ""
else
	SED_INPLACE := -i
endif
SERVICE_LIST := $(shell echo $(SERVICES) | tr ',' '\n')

install:
	@git submodule sync --recursive; \
	git submodule update --init --recursive --remote;

copy:
	@for service in $(SERVICE_LIST); do \
		echo "Copying files for $$service"; \
		if [[ $$service == "node" ]]; then \
			if [ ! -f "./config/ssv.node.yaml" ]; then \
				cp ./config/example.ssv.node.yaml ./config/ssv.node.yaml; \
			fi; \
			if [ ! -f "./config/dkg.node.yaml" ]; then \
				cp ./config/example.dkg.node.yaml ./config/dkg.node.yaml; \
			fi; \
		elif [[ $$service =~ ^node\.[1-8]$$ ]]; then \
			n=$$(echo $$service | sed 's/node\.//g'); \
			if [ ! -f "./config/ssv.node.$$n.yaml" ]; then \
				cp ./config/example.ssv.node.yaml ./config/ssv.node.$$n.yaml; \
			fi; \
			if [ ! -f "./config/dkg.node.$$n.yaml" ]; then \
				cp ./config/example.dkg.node.yaml ./config/dkg.node.$$n.yaml; \
			fi; \
			sed $(SED_INPLACE) "s|./data/ssv-node/db|./data/ssv-node-$$n/db|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|16000|$$(($$((16000)) + $$n))|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|17000|$$(($$((16000)) + $$n))|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|sk.txt|sk.$$n.txt|g" ./config/dkg.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|3030|$$(($$((3030)) + $$n))|g" ./config/dkg.node.$$n.yaml; \
		elif [[ $$service == "exporter" ]]; then \
			if [ ! -f "./config/ssv.exporter.yaml" ]; then \
				cp ./config/example.ssv.exporter.yaml ./config/ssv.exporter.yaml; \
			fi; \
		fi; \
    done;

generate_operator_keys:
	@docker run --rm -it 'bloxstaking/ssv-node:latest' /go/bin/ssvnode generate-operator-keys;

up:
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
		fi; \
	done; \
	echo "Running stack: $$stack"; \
	docker compose up $$stack -d;

down:
	@echo "Stopping all services"; \
	docker compose down;


