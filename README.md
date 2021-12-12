# srv6-calico-vpp-tests
Collection of scripts for testbed deployment, for k8s environments with Calico-VPP and SRv6 enabled


sudo kubeadm join [fd10::1000]:6443 --token xvyy6d.6iw5i2ivk55xsklv --discovery-token-ca-cert-hash sha256:9663a53e8b06f325d089d58515669d756f7f0cd158f09d84215b29e5be162253

sudo kubeadm join 192.168.10.254:6443 --token xvyy6d.6iw5i2ivk55xsklv --ignore-preflight-errors=SystemVerification --discovery-token-unsafe-skip-ca-verification 


worker
sudo ip -6 route add fd10::/64 via fd11::1020 && \
sudo ip  route add 192.168.10.0/24 via 192.168.11.3

master
sudo ip -6 route add fd11::/64 via fd10::1020 && \
sudo ip  route add 192.168.11.0/24 via 192.168.10.3

mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc # add autocomplete permanently to your bash shell.