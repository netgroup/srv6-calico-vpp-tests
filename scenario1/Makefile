SHELL := /bin/bash

.PHONY: setup
setup:
	@echo "setup scenario1"

.PHONY: create-python-venv
create-python-venv:
	@echo "create python venv"
	virtualenv -p python3 .venv

.PHONY: install-python-dependencies
install-python-dependencies:
	@echo "install python dependencies"
	sudo .venv/bin/pip install -r ../mininet/rose-srv6-tutorial/requirements.txt

.PHONY: start-mininet-scenario
start-mininet-scenario:
	@echo "start mininet network for scenario1"
	sudo screen -S scenario1 -d -m ./start-mininet-net.sh

.PHONY: stop-mininet-scenario
stop-mininet-scenario:
	@echo "stop mininet network for scenario1"
	sudo screen -S scenario1 -X stuff "quit^M"

.PHONY: create-veth-pair-scenario
create-veth-pair-scenario:
	@echo "Create veth pair with srv6-calico-vpp-tests_master"
	../scripts/create-veth-pair.sh r3 0 srv6-calico-vpp-tests_master srv6-calico-vpp-tests fd10::1020
	#@echo "Create veth pair with srv6-calico-vpp-tests_worker1"
	#../create-veth-pair.sh r3 1 srv6-calico-vpp-tests_master fd20::1020
	