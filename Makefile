pull_submodules:
	git submodule update --init --recursive

copy_example_files:
	for file in ./env/example.*.env; do \
		cp $$file ./env/`basename $$file | sed 's/example.//g'`; \
	done
	for file in ./config/example.*.yaml; do \
		cp $$file ./config/`basename $$file | sed 's/example.//g'`; \
	done

generate_operator_keys:
	docker run --rm -it 'bloxstaking/ssv-node:latest' /go/bin/ssvnode generate-operator-keys

run_all:
	docker compose up -d;

run_node:
	docker compose up -d --build ssv-node-1 dkg-node-1;

run_exporter:
	docker compose up -d --build ssv-exporter;

run_messenger:
	docker compose up -d --build dkg-messenger;

stop_all:
	docker compose down;

stop_node:
	docker compose down ssv-node-1 dkg-node-1;

stop_exporter:
	docker compose down ssv-exporter;

stop_messenger:
	docker compose down dkg-messenger;



