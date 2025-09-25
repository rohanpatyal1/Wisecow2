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

# quick run and deploy steps
1.Build.
docker build -t ghcr.io/<GH_USER>/wisecow:latest .
docker push ghcr.io/<GH_USER>/wisecow:latest

2.Minikube / Kind
Create namespace & apply manifests:

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
If using Minikube and testing ingress:
minikube addons enable ingress

# then port-forward or use minikube tunnel for LoadBalancer
3.Set up GitHub Actions
Commit the workflow .github/workflows/ci-cd.yml
Add secret KUBECONFIG (paste kubeconfig)
When you push to main, workflow will build, push image, then apply manifests

4.TLS
For production, install cert-manager and create a ClusterIssuer for Let's Encrypt:
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/<version>/cert-manager.yaml
Create ClusterIssuer resource (ACME staging/production).
Annotate ingress with cert-manager.io/cluster-issuer: "letsencrypt"
