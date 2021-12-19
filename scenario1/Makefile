SHELL := /bin/bash
CWD = $(shell pwd)


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
	../scripts/create-veth-pair.sh r3 0 srv6-calico-vpp-tests_master srv6-calico-vpp-tests fd10::1020/64 192.168.10.3/24
	@echo "Create veth pair with srv6-calico-vpp-tests_worker1"
	../scripts/create-veth-pair.sh r3 1 srv6-calico-vpp-tests_worker1 srv6-calico-vpp-tests fd11::1020/64 192.168.11.3/24
	#@echo "Create veth pair with srv6-calico-vpp-tests_worker2"
	#../scripts/create-veth-pair.sh r8 2 srv6-calico-vpp-tests_worker2 srv6-calico-vpp-tests fd12::1020/64

.PHONY: create-virsh-networks
create-virsh-networks:
	@echo "Create virsh networks for scenario1"
	sudo virsh net-create ./virsh/virbr-tests0.xml
	sudo virsh net-create ./virsh/virbr-tests1.xml
	sudo virsh net-create ./virsh/virbr-tests2.xml

.PHONY: clean-virsh-networks
clean-virsh-networks:
	@echo "Destroy virsh networks for scenario1"
	sudo virsh net-undefine srv6-calico-vpp-tests0
	sudo virsh net-undefine srv6-calico-vpp-tests1
	sudo virsh net-undefine srv6-calico-vpp-tests2

.PHONY: start-scenario1
start-scenario1:
	@echo "start scenario1"
	
	@$(MAKE) start-mininet-scenario
	@$(MAKE) create-virsh-networks
	@$(MAKE) start-cluster
	@$(MAKE) create-veth-pair-scenario
	
.PHONY: start-cluster
start-cluster:
	@echo "start master node scenario1"
	set -o allexport; source .master.env; set +o allexport && vagrant up
	@echo "start worker1 node scenario1"
	set -o allexport; source .worker1.env; set +o allexport && vagrant up

.PHONY: destroy-scenario1
destroy-scenario1:
	@echo "destroy scenario1"
	@$(MAKE) stop-mininet-scenario
	@$(MAKE) destroy-cluster
	@$(MAKE) clean-virsh-networks


.PHONY: destroy-cluster
destroy-cluster:
	@echo "destroy master node scenario1"
	set -o allexport; source .master.env; set +o allexport && vagrant destroy -f
	@echo "destroy worker1 node scenario1"
	set -o allexport; source .worker1.env; set +o allexport && vagrant destroy -f