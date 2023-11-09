-include .env
SHELL := /bin/bash
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Darwin)
	SED_INPLACE := -i ""
else
	SED_INPLACE := -i
endif
SERVICE_LIST := $(shell echo $(SERVICES) | tr ',' '\n')

ifeq ($(SERVICE_LIST),)
	SERVICE_LIST := node

install:
	@git submodule sync --recursive; \
	git submodule update --init --recursive --remote;

copy:
	@for service in $(SERVICE_LIST); do \
		echo "Copying files for $$service"; \
		if [[ $$service == "node" ]]; then \
			if [ ! -f "./config/dkg.node.yaml" ]; then \
				cp ./config/example.dkg.node.yaml ./config/dkg.node.yaml; \
			fi; \
			if [ ! -f "./config/ssv.node.yaml" ]; then \
				cp ./config/example.ssv.node.yaml ./config/ssv.node.yaml; \
			fi; \
		elif [[ $$service =~ ^node\.[1-8]$$ ]]; then \
			n=$$(echo $$service | sed 's/node\.//g'); \
			if [ ! -f "./config/dkg.node.$$n.yaml" ]; then \
				cp ./config/example.dkg.node.yaml ./config/dkg.node.$$n.yaml; \
			fi; \
			if [ ! -f "./config/ssv.node.$$n.yaml" ]; then \
				cp ./config/example.ssv.node.yaml ./config/ssv.node.$$n.yaml; \
			fi; \
			sed $(SED_INPLACE) "s|password.txt|password.$$n.txt|g" ./config/dkg.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|encrypted.json|encrypted.$$n.json|g" ./config/dkg.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|3030|$$(($$((3030)) + $$n))|g" ./config/dkg.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|dkg-node/log|dkg-node-$$n/log|g" ./config/dkg.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|dkg-node/db|dkg-node-$$n/db|g" ./config/dkg.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|password.txt|password.$$n.txt|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|encrypted.json|encrypted.$$n.json|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|ssv-node/db|ssv-node-$$n/db|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|16000|$$(($$((16000)) + $$n))|g" ./config/ssv.node.$$n.yaml; \
			sed $(SED_INPLACE) "s|17000|$$(($$((16000)) + $$n))|g" ./config/ssv.node.$$n.yaml; \
		elif [[ $$service == "exporter" ]]; then \
			if [ ! -f "./config/ssv.exporter.yaml" ]; then \
				cp ./config/example.ssv.exporter.yaml ./config/ssv.exporter.yaml; \
			fi; \
		fi; \
    done;

generate_operator_keys:
	@for service in $(SERVICE_LIST); do \
		keystore_file=""; \
		password_file=""; \
		if [ $$service = "node" ]; then \
			keystore_file="./keys/encrypted.json"; \
			password_file="./keys/password.txt"; \
		elif [[ "$$service" =~ ^node\.[1-8]$$ ]]; then \
			n=$$(echo $$service | sed 's/node\.//g'); \
			keystore_file="./keys/encrypted.$$n.json"; \
			password_file="./keys/password.$$n.txt"; \
		fi; \
		if [ -f $$keystore_file ]; then \
			echo "Keystore file already exists for $$service"; \
			continue; \
		fi; \
		echo "Enter a keystore file password for $$service"; \
		password=""; \
		read -s password; \
		echo $$password > $$password_file; \
		docker run --name ssv-node-key-generation -v "$$password_file":/password -it "bloxstaking/ssv-node:latest" /go/bin/ssvnode generate-operator-keys --password-file=password && docker cp ssv-node-key-generation:/encrypted_private_key.json $$keystore_file && docker rm ssv-node-key-generation; \
	done;

migrate_operator_keys:
	@for service in $(SERVICE_LIST); do \
		secret_key_file=""; \
		keystore_file=""; \
		password_file=""; \
		if [ $$service = "node" ]; then \
			secret_key_file="./keys/sk.txt"; \
			keystore_file="./keys/encrypted.json"; \
			password_file="./keys/password.txt"; \
		elif [[ "$$service" =~ ^node\.[1-8]$$ ]]; then \
			n=$$(echo $$service | sed 's/node\.//g'); \
			secret_key_file="./keys/sk.$$n.txt"; \
			keystore_file="./keys/encrypted.$$n.json"; \
			password_file="./keys/password.$$n.txt"; \
		fi; \
		echo "Enter a keystore file password for $$service"; \
		password=""; \
		read -s password; \
		echo $$password > $$password_file; \
		docker run --name ssv-node-key-generation \
		-v "$$password_file":/password \
		-v "$$secret_key_file":/private-key \
		-it bloxstaking/ssv-node:latest /go/bin/ssvnode generate-operator-keys \
		--password-file=/password  --operator-key-file=/private-key && \
		docker cp ssv-node-key-generation:/encrypted_private_key.json \
		$$keystore_file && \
		docker rm ssv-node-key-generation; \
	done;
	
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
	docker compose up $$stack --build -d;

down:
	@echo "Stopping all services"; \
	docker compose down;


