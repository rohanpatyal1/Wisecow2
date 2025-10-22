# Cow wisdom web server

## Prerequisites

```
sudo apt install fortune-mod cowsay -y
```

## How to use?

1. Run `./wisecow.sh`
2. Point the browser to server port (default 4499)

## What to expect?
![wisecow](https://github.com/nyrahul/wisecow/assets/9133227/8d6bfde3-4a5a-480e-8d55-3fef60300d98)

# Problem Statement
Deploy the wisecow application as a k8s app

## Requirement
1. Create Dockerfile for the image and corresponding k8s manifest to deploy in k8s env. The wisecow service should be exposed as k8s service.
2. Github action for creating new image when changes are made to this repo
3. [Challenge goal]: Enable secure TLS communication for the wisecow app.

## Expected Artifacts
1. Github repo containing the app with corresponding dockerfile, k8s manifest, any other artifacts needed.
2. Github repo with corresponding github action.
3. Github repo should be kept private and the access should be enabled for following github IDs: nyrahul

## Workspace additions in this fork

Files added/updated to help containerize and deploy:

- `Dockerfile` - builds an Ubuntu-based image with cowsay, fortune and nc and runs `wisecow.sh`.
- `k8s/deployment.yaml` - Deployment using image `ghcr.io/<your-org>/wisecow:latest` (update as needed).
- `k8s/service.yaml` - ClusterIP Service exposing port 80 -> container 4499.
- `k8s/ingress.yaml` - Ingress template with TLS placeholder (replace secret or use cert-manager).
- `k8s/kubearmor-policy.yaml` - Optional KubeArmor deny-all template (adjust to allow required binaries).
- `.github/workflows/ci-cd.yml` - GitHub Actions workflow to build and push image to GHCR and optionally deploy to a cluster if `KUBE_CONFIG_DATA` secret is set.
- `scripts/system_health_monitor.sh` - Simple system health monitor (bash).
- `scripts/app_health_check.py` - HTTP-based application health checker (Python, requires `requests`).

## Quick local test (Docker)

Build:

```bash
docker build -t wisecow:local .
```

Run:

```bash
docker run --rm -p 4499:4499 wisecow:local
```

Visit http://localhost:4499

## Deploy to Kubernetes (example using kubectl with current kubeconfig)

Apply manifests:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
# If you have an ingress controller and TLS secret, apply ingress
kubectl apply -f k8s/ingress.yaml
```

Notes:
- Update the image name in `k8s/deployment.yaml` to your registry/org (the workflow pushes to `ghcr.io/<owner>/wisecow:latest`).
- For CI/CD deploy, set `KUBE_CONFIG_DATA` secret in the repository to a base64-encoded kubeconfig.

