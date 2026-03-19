# 🚀 Kubernetes Installation on Ubuntu 24.04 | Step-by-Step Guide (kubeadm + containerd + Calico)

[![Kubernetes Docs](https://img.shields.io/badge/docs-official-blue)](https://kubernetes.io/docs/)
[![Calico Docs](https://img.shields.io/badge/calico-docs-orange)](https://projectcalico.docs.tigera.io/)
[![Slack Community](https://img.shields.io/badge/slack-join-purple)](https://slack.k8s.io/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/OS-Ubuntu%2024.04-orange)]()
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.32-blue)](https://kubernetes.io/)
[![Setup](https://img.shields.io/badge/setup-automated-success)]()
[![Maintained](https://img.shields.io/badge/status-maintained-brightgreen)]()

---

## 📑 Table of Contents

- Overview  
- Quick Start  
- Automated Installation  
- Why This Guide  
- Features  
- Installation Guide  
- Getting Started Resources  
- Advanced Topics  
- Useful Links  
- Project Structure  
- Important Notes  
- License  
- Keywords  

---

## 📚 Overview

This repository provides a **complete, production-ready Kubernetes installation guide on Ubuntu 24.04** using:

- **kubeadm** → cluster bootstrap  
- **containerd** → container runtime  
- **Calico** → networking (CNI)

It includes both:
- ✅ **Automated installation script**
- ✅ **Step-by-step manual guide**

Designed for:
- DevOps Engineers  
- Cloud Engineers  
- Kubernetes Beginners & Professionals  

---

## 🚀 Quick Start (Recommended)

Run the automated installation:

```bash
chmod +x install-kubernetes.sh
./install-kubernetes.sh
```

👉 This will:
- Install containerd
- Setup Kubernetes (kubeadm, kubelet, kubectl)
- Initialize cluster
- Install Calico network
- Configure single-node cluster

---

## 🤖 Automated Installation

Script included:

```
install-kubernetes.sh
```

✔ Fully automated Kubernetes setup  
✔ Production-ready defaults  
✔ Minimal manual intervention required  

---

## ⭐ Why This Guide?

- Optimized for **Ubuntu 24.04 LTS**
- Uses **containerd (modern standard)** instead of Docker
- Includes **Calico networking**
- Covers **real-world DevOps setup**
- Clean, structured, and beginner-friendly

---

## ⚡ Features

- ✅ Kubernetes cluster setup using kubeadm  
- ✅ Containerd runtime with systemd cgroup  
- ✅ Calico networking integration  
- ✅ Single-node (Control Plane) deployment  
- ✅ Production-ready configuration  
- ✅ Troubleshooting included  

---

## 📘 Manual Installation Guide

For detailed explanation and step-by-step setup:

👉 **[install-kubernetes-ubuntu-24.md](./install-kubernetes-ubuntu-24.md)**

---

## 🌱 Getting Started (Official Resources)

- Kubernetes Docs: https://kubernetes.io/docs/  
- Calico Docs: https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart  
- kubectl Cheat Sheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/  

---

## 🚀 Advanced Topics Covered

- Kubernetes Networking (Calico, Cilium, Flannel)  
- Cluster Security & Hardening  
- High Availability (HA) Setup  
- Monitoring (Prometheus + Grafana)  
- CI/CD Integration with Kubernetes  

---

## 🔗 Useful Links

- https://kubernetes.io/docs/  
- https://projectcalico.docs.tigera.io  
- https://slack.k8s.io/  
- https://kubernetes.io/blog/  

---

## 📂 Project Structure

```
.
├── README.md
├── install-kubernetes.sh
├── install-kubernetes-ubuntu-24.md
└── assets/
```

---

## ⚠️ Important Notes

- Swap must be disabled before installation  
- Ensure correct node IP (multi-NIC setups)  
- Use firewall/security groups when exposing services  
- For production, use **LoadBalancer instead of NodePort**  
- Always verify cluster using:
  ```bash
  kubectl get nodes -o wide
  kubectl get pods -A
  ```

---

## 🌍 Share & Support

If this guide helped you:

- ⭐ Star this repository  
- 🔗 Share on LinkedIn / Dev.to  
- 📢 Help others learn Kubernetes  

---

## 📄 License

MIT License

---

## 📈 Keywords (SEO)

kubernetes install ubuntu 24.04  
kubeadm setup ubuntu server  
kubernetes single node setup  
containerd kubernetes installation  
calico kubernetes setup  
devops kubernetes guide  
install kubernetes ubuntu server  
kubernetes cluster setup step by step  

---
