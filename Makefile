
CWD = $(shell pwd)

.PHONY: build-base-box
build-base-box:
	sudo chmod +r /boot/vmlinuz-*
	export VAGRANT_VAGRANTFILE=$(CWD)/vagrant/basebox/Vagrantfile; \
	export VAGRANT_LIBVIRT_VIRT_SYSPREP_OPERATIONS="defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids"; \
	export VAGRANT_LIBVIRT_VIRT_SYSPREP_OPTIONS="--delete /etc/machine-id --firstboot-command 'systemd-machine-id-setup; sleep 1; netplan apply'"; \
	vagrant up && \
	vagrant package --output srv6-calico-vpp-base.box && \
	vagrant destroy -f
	vagrant box add --name srv6-calico-vpp-base srv6-calico-vpp-base.box
	rm srv6-calico-vpp-base.box

.PHONY: clean-base-box
clean-base-box:
	export VAGRANT_VAGRANTFILE=$(CWD)/vagrant/basebox/Vagrantfile; \
	vagrant destroy -f
	vagrant box remove -f srv6-calico-vpp-base --all --no-color
	virsh vol-delete --pool default srv6-calico-vpp-base_vagrant_box_image_0.img

.PHONY: start-master	
start-master:
	export VAGRANT_VAGRANTFILE=$(CWD)/vagrant/master/Vagrantfile; \
	vagrant up 

.PHONY: start-master	
destroy-master:
	export VAGRANT_VAGRANTFILE=$(CWD)/vagrant/master/Vagrantfile; \
	vagrant destroy -f