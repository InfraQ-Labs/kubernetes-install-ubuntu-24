# 🚀 Kubernetes Installation on Ubuntu Server 24.04 (Single-Node Master) — Production-Ready Guide

> ✅ **SEO Keywords:** Kubernetes Ubuntu 24.04 install, kubeadm setup Ubuntu, Kubernetes single node setup, containerd Kubernetes Ubuntu, Calico network Kubernetes, install Kubernetes step by step

This guide provides a **complete, production-style Kubernetes setup** on Ubuntu Server using **kubeadm + containerd**, with networking via **Calico**.

---

## 📌 System Requirements

- OS: Ubuntu Server 24.04 (or 25.04)
- CPU: 2 vCPU minimum
- RAM: 8GB minimum (16GB recommended)
- Network: Static IP preferred
- Swap: Disabled (mandatory)

---

## ⚙️ 1. Disable Swap (Required)

```bash
sudo swapoff -a
sudo free -h
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo rm -f /swap.img
```

> 🔎 Kubernetes requires accurate memory tracking. Swap breaks scheduling logic.

---

## 🔧 2. Load Required Kernel Modules

```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

---

## 🔁 3. Make Modules Persistent

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

---

## 🌐 4. Configure Sysctl Parameters

```bash
cat <<EOT | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOT

sudo sysctl --system
```

---

## 📦 5. Install Base Dependencies

```bash
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
```

---

## 🐳 6. Add Containerd Repository

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/containerd.gpg

sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

---

## 📥 7. Install Containerd

```bash
sudo apt update
sudo apt install -y containerd.io
```

---

## ⚙️ 8. Configure Containerd (systemd cgroup)

```bash
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
```

> 🔎 Kubernetes requires matching cgroup driver (`systemd`) for stability.

---

## ☸️ 9. Add Kubernetes Repository

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key \
| sudo gpg --dearmor -o /etc/apt/keyrings/k8s.gpg

echo 'deb [signed-by=/etc/apt/keyrings/k8s.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' \
| sudo tee /etc/apt/sources.list.d/k8s.list

sudo apt update
```

---

## 📦 10. Install Kubernetes Components

```bash
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

---

## 🚀 11. Initialize Kubernetes Cluster

```bash
ip a | grep enp0s8
```

```bash
sudo kubeadm config images pull
```

```bash
sudo kubeadm init \
--apiserver-advertise-address=192.168.56.26 \
--pod-network-cidr=10.244.0.0/16
```

> 🔎 Replace `192.168.56.26` with your actual server IP.

If needed:
```bash
sudo kubeadm reset
```

---

## 🔐 12. Configure kubectl Access

```bash
mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

## 🌐 13. Install Calico Network Plugin

```bash
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.30.0/manifests/calico.yaml

kubectl apply -f calico.yaml

kubectl set env daemonset/calico-node \
-n kube-system IP_AUTODETECTION_METHOD=interface=enp0s8
```

---

## ✅ 14. Verify Cluster Status

```bash
kubectl get pods -n kube-system
kubectl get pods -A
kubectl get nodes -o wide
```

If node is `NotReady`:

```bash
sudo systemctl restart containerd
sudo systemctl restart kubelet
```

---

## 📦 15. Deploy Test Application (NGINX)

```bash
kubectl create ns demo-app

kubectl create deployment nginx-app \
--image=nginx \
--replicas=2 \
-n demo-app

kubectl get deployment -n demo-app
kubectl get pods -n demo-app
```

---

## 🌍 16. Expose Application (NodePort)

```bash
kubectl expose deployment nginx-app \
-n demo-app \
--type NodePort \
--port 80

kubectl get svc -n demo-app
```

Access:
```bash
curl http://<NODE-IP>:<NODE-PORT>
```

---

## 🧠 17. Allow Pods on Master Node (Single Node Setup)

```bash
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-
```

---

## 🛠️ 18. Fix Node IP (If Required)

```bash
cat <<EOT | sudo tee /var/lib/kubelet/kubeadm-flags.env
KUBELET_KUBEADM_ARGS="--container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.10 --node-ip=192.168.56.26"
EOT
```

```bash
echo "127.0.1.1 lnx25-docker" | sudo tee -a /etc/hosts
echo "192.168.56.26 lnx25-docker" | sudo tee -a /etc/hosts
```

```bash
sudo systemctl restart kubelet
```

---

## 🎯 Final Verification

```bash
kubectl get nodes -o wide
kubectl get pods -A
```

🎉 **Your Kubernetes cluster is now fully operational!**

---

## 📌 Summary

- Runtime: containerd
- Orchestration: Kubernetes (kubeadm)
- Network: Calico
- Mode: Single-node (Master + Worker)

---

## ⚠️ Production Notes

- Use LoadBalancer (MetalLB) instead of NodePort
- Enable RBAC + Network Policies
- Configure Ingress Controller (NGINX/Traefik)
- Use persistent storage (CSI drivers)
- Secure API server (TLS, firewall rules)

---

## 📄 License

MIT License — Free to use, modify, and distribute.

---

## 🔍 SEO Tags

`kubernetes install ubuntu 24.04`  
`kubeadm setup ubuntu server`  
`install kubernetes step by step`  
`containerd kubernetes ubuntu`  
`calico network kubernetes setup`  
`single node kubernetes cluster`  
