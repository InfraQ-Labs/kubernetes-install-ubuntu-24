#!/bin/bash

set -e

echo "🚀 Starting Kubernetes Installation on Ubuntu 24.04..."

### 1. Disable Swap
echo "🔧 Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

### 2. Load Kernel Modules
echo "🔧 Loading kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

### 3. Configure Sysctl
echo "🔧 Configuring sysctl..."
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

### 4. Install Dependencies
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

### 5. Install Containerd
echo "📦 Installing containerd..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/containerd.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt install -y containerd.io

### 6. Configure Containerd
echo "⚙️ Configuring containerd..."
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

### 7. Add Kubernetes Repo
echo "📦 Adding Kubernetes repo..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/k8s.gpg

echo "deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | \
sudo tee /etc/apt/sources.list.d/k8s.list

sudo apt update

### 8. Install Kubernetes Components
echo "📦 Installing kubeadm, kubelet, kubectl..."
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

### 9. Initialize Cluster
echo "🚀 Initializing Kubernetes cluster..."

IP_ADDR=$(hostname -I | awk '{print $1}')

sudo kubeadm init \
  --apiserver-advertise-address=$IP_ADDR \
  --pod-network-cidr=10.244.0.0/16

### 10. Setup kubectl
echo "🔧 Configuring kubectl..."

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### 11. Install Calico
echo "🌐 Installing Calico network..."

curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.30.0/manifests/calico.yaml
kubectl apply -f calico.yaml

### 12. Allow Pods on Master (Single Node)
echo "⚙️ Allowing pods on control-plane..."

kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

### 13. Final Status
echo "✅ Kubernetes installation complete!"

kubectl get nodes -o wide
kubectl get pods -A

echo "🎉 Cluster is ready!"
