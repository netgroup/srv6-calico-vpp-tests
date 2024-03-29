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
	@echo "Create veth pair with srv6-calico-vpp-tests_worker2"
	../scripts/create-veth-pair.sh r8 2 srv6-calico-vpp-tests_worker2 srv6-calico-vpp-tests fd12::1020/64 192.168.12.3/24

.PHONY: add-routes-localsids-scenario
add-routes-localsids-scenario:
	@echo "Add routes localsids with srv6-calico-vpp-tests_master"
	../scripts/add-route-localsids.sh r3 0 srv6-calico-vpp-tests_master srv6-calico-vpp-tests fcdd:0:0:aa::/64 fd10::1000
	@echo "Add routes localsids with srv6-calico-vpp-tests_worker1"
	../scripts/add-route-localsids.sh r3 1 srv6-calico-vpp-tests_worker1 srv6-calico-vpp-tests fcdd:0:0:11aa::/64 fd11::1000
	@echo "Add route localsids with srv6-calico-vpp-tests_worker2"
	../scripts/add-route-localsids.sh r8 2 srv6-calico-vpp-tests_worker2 srv6-calico-vpp-tests fcdd:0:0:12aa::/64 fd12::1000
 

.PHONY: create-virsh-networks
create-virsh-networks:
	@echo "Create virsh networks for scenario1"
	sudo virsh net-create ./virsh/virbr-tests0.xml
	sudo virsh net-create ./virsh/virbr-tests1.xml
	sudo virsh net-create ./virsh/virbr-tests2.xml

.PHONY: clean-virsh-networks
clean-virsh-networks:
	@echo "Destroy virsh networks for scenario1"
	sudo virsh net-destroy srv6-calico-vpp-tests0
	sudo virsh net-destroy srv6-calico-vpp-tests1
	sudo virsh net-destroy srv6-calico-vpp-tests2

.PHONY: start-scenario1
start-scenario1:
	@echo "start scenario1"
	
	@$(MAKE) start-mininet-scenario
	@$(MAKE) create-virsh-networks
	@$(MAKE) start-cluster
	@$(MAKE) create-veth-pair-scenario
	@$(MAKE) add-routes-localsids-scenario
	@$(MAKE) join-nodes-cluster
	
.PHONY: start-cluster
start-cluster:
	@echo "start master node scenario1"
	set -o allexport; source .master.env; set +o allexport && vagrant up
	@echo "start worker1 node scenario1"
	set -o allexport; source .worker1.env; set +o allexport && vagrant up
	@echo "start worker2 node scenario1"
	set -o allexport; source .worker2.env; set +o allexport && vagrant up

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
	@echo "destroy worker2 node scenario1"
	set -o allexport; source .worker2.env; set +o allexport && vagrant destroy -f

.PHONY: join-nodes-cluster
join-nodes-cluster:
	@echo "join worker1 node scenario1"
	set -o allexport; source .worker1.env; set +o allexport && vagrant ssh -c "sudo kubeadm join 192.168.10.254:6443 --token xvyy6d.6iw5i2ivk55xsklv --ignore-preflight-errors=SystemVerification --discovery-token-unsafe-skip-ca-verification"
	@echo "join worker2 node scenario1"
	set -o allexport; source .worker2.env; set +o allexport && vagrant ssh -c "sudo kubeadm join 192.168.10.254:6443 --token xvyy6d.6iw5i2ivk55xsklv --ignore-preflight-errors=SystemVerification --discovery-token-unsafe-skip-ca-verification"