# Wisecow Kubernetes Deployment

## Overview
Containerizes and deploys the Wisecow application on Kubernetes (Minikube) with TLS and CI/CD via GitHub Actions.

## Artifacts
- `Dockerfile`: Builds Wisecow container with fortune-mod and cowsay.
- `wisecow.sh`: Netcat-based HTTP server serving fortune + cowsay.
- `deployment.yaml`, `service.yaml`, `ingress.yaml`: Kubernetes manifests.
- `tls.crt`, `tls.key`: Self-signed TLS certificate for wisecow.local.
- `.github/workflows/docker-publish.yml`: CI/CD pipeline.

## Setup & Verification
1. **Build & Push**:
   ```bash
   cd ~/wisecow/wisecow-kubernetes
   docker build -t vyshnaviboddu/wisecow:latest .
   docker push vyshnaviboddu/wisecow:latest

2. **Deploy**:
   ```bash
kubectl apply -f deployment.yaml,service.yaml,ingress.yaml
kubectl create secret tls wisecow-tls --cert=tls.crt --key=tls.key
3. **Enable Ingress**:
```bash
minikube addons enable ingress

4. **HTTPS Test**:
```bash
minikube ip
echo "192.168.49.2 wisecow.local" | sudo tee -a /etc/hosts
curl https://wisecow.local --insecure

Output: Cowsay fortune message via TLS-terminated Ingress.

5. **HTTP Test (Optional)**:
```bash
echo "127.0.0.1 wisecow.local" | sudo tee -a /etc/hosts
kubectl port-forward svc/wisecow-service 4499:4499
curl http://localhost:4499

**CI/CD**
GitHub Actions (docker-publish.yml) builds and pushes the Docker image on commits to main.

**Status**
✅ All requirements complete: Dockerization, Kubernetes deployment, TLS, CI/CD, HTTPS access verified.
