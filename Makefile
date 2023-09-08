SHELL := /bin/bash
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)  # macOS
	SED_INPLACE := -i ""
else
	SED_INPLACE := -i
endif
SERVICES := $(shell grep SERVICES .env | cut -d '=' -f2)
SERVICE_LIST := $(shell echo $(SERVICES) | tr ',' '\n')

pull_submodules:
	@git submodule update --init --recursive

copy_example_files:
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
		fi \
	done


generate_operator_keys:
	@docker run --rm -it 'bloxstaking/ssv-node:latest' /go/bin/ssvnode generate-operator-keys

run:
	@stack=""
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
		fi \
	done; \
	echo "Stack list: $$stack"; \
	docker compose up -d --build $$stack;

stop:
	@echo "Stopping all services"; \
	docker compose down;


