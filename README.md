# Containerisation and Deployment of Wisecow Application on Kubernetes

## Repository
https://github.com/nyrahul/wisecow

## Prerequisites

```
sudo apt install fortune-mod cowsay -y
```


## How to use?

1. Run `./wisecow.sh`
2. Point the browser to server port (default 4499)
3. Access securely via HTTPS if TLS is enabled

## CI/CD Pipeline
- Docker image automatically built and pushed to container registry on commit.
- Optional: Automatic deployment to Kubernetes cluster after image build.

## What to expect?
![wisecow](https://github.com/nyrahul/wisecow/assets/9133227/8d6bfde3-4a5a-480e-8d55-3fef60300d98)

# Problem Statement
Deploy the Wisecow application as a Kubernetes application

## Requirements
1. **Dockerization:**  
   - Develop a Dockerfile for creating a container image of the Wisecow application.

2. **Kubernetes Deployment:**  
   - Craft Kubernetes manifest files for deploying the Wisecow application in a Kubernetes environment.  
   - The Wisecow app must be exposed as a Kubernetes service for accessibility.

3. **CI/CD (GitHub Actions):**  
   - Automate the build and push of the Docker image whenever changes are committed.  
   - Optional: Automatically deploy the updated application to the Kubernetes environment after a successful build.

4. **TLS Implementation (Challenge Goal):**  
   - Ensure that the Wisecow application supports secure HTTPS communication.

## Expected Artifacts
- Dockerfile for the application
- Kubernetes manifest files (deployment.yaml, service.yaml, ingress.yaml)
- GitHub Actions workflow for CI/CD
- TLS certificate and key for secure communication

