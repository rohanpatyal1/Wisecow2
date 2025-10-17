# Wisecow — Cow wisdom web server

Wisecow is a tiny HTTP server that serves a random "fortune" wrapped in an ASCII cow (via `cowsay`) on port 4499. The server is implemented as a POSIX shell script using `netcat` to listen on a TCP port and `fortune` + `cowsay` to build the response.

This repository contains:
- `wisecow.sh` — the small server script.
- `Dockerfile` — builds a minimal Ubuntu-based image with `fortune`, `cowsay` and `netcat` and runs `wisecow.sh`.
- `k8s/deployment.yaml` — Kubernetes Deployment + Service manifest (exposes NodePort 30499 by default).
- `scripts/` — helper scripts (health checks, system monitors) for local/ops use.

This README documents everything you need to run, build, debug, and deploy the application locally or on Kubernetes.

---

## Quick summary

- App port: 4499 (HTTP)
- Docker image name used locally in this guide: `wisecow:local`
- Kubernetes Service NodePort (optional fixed): `30499` -> maps to 4499 in the pod (see `k8s/deployment.yaml`).

---

## Prerequisites

To run locally using Docker
- Docker Desktop installed and running (Linux/Windows/macOS). Make sure Docker daemon is active.

To run natively (not recommended for Windows without WSL / POSIX tools)
- bash (POSIX shell)
- netcat (nc)
- fortune-mod
- cowsay

To run on Kubernetes
- kubectl configured to talk to your cluster (minikube, kind, GKE, EKS, AKS, etc.)

Utilities used in examples
- curl (for health checks)

Notes on platform specifics
- The project scripts are POSIX shell based. On Windows use WSL or run via Docker. The Dockerfile normalizes line endings so the image runs correctly even if files on the host have CRLF.

---

## Files and purpose (short)

- `wisecow.sh` — main server logic. Listens on TCP port 4499 with `nc -lN` and responds with a simple HTTP/1.1 response body containing a `cowsay` of a random `fortune`.
- `Dockerfile` — builds the app image and ensures required packages are installed. Also fixes CRLF line endings so the container works on Windows hosts.
- `k8s/deployment.yaml` — Kubernetes Deployment (1 replica by default) and a `NodePort` Service exposing the app port.
- `scripts/app_health_checker.sh` — curl-based health check that expects HTTP 200.
- `scripts/system_health_monitor.sh` — an example system monitor script.

---

## Build and run with Docker (recommended)

Steps below show both PowerShell (Windows) and POSIX shell variants.

1) Build the Docker image

PowerShell / Windows (pwsh):
```powershell
cd 'C:\Users\caysu\Downloads\Accuknox\wisecow'
docker build -t wisecow:local .
```

bash / macOS / Linux:
```bash
cd ~/path/to/wisecow
docker build -t wisecow:local .
```

2) Run the container (map port 4499)

PowerShell:
```powershell
# remove any previously created container with the same name
docker rm -f wisecow_local 2>$null || $true
docker run -d --name wisecow_local -p 4499:4499 wisecow:local
```

bash:
```bash
docker rm -f wisecow_local || true
docker run -d --name wisecow_local -p 4499:4499 wisecow:local
```

3) Check the container status (PowerShell / bash)
```powershell
docker ps --filter name=wisecow_local -a
docker logs wisecow_local --tail 200
```

4) Health check via curl
```powershell
curl -s -o /dev/null -w "%{http_code}" http://localhost:4499/
# expected: 200
```

Or open in your browser: http://localhost:4499/

5) Stop & remove the container
```powershell
docker stop wisecow_local
docker rm wisecow_local
```

Notes
- If you see an error like `/usr/bin/env: 'bash\r': No such file or directory`, rebuild after normalizing line endings. The provided `Dockerfile` already runs `sed -i 's/\r$//' /usr/local/bin/wisecow.sh` to prevent that when building the image.
- If container exits with "Install prerequisites.", make sure the Dockerfile installed `fortune` and `cowsay` (it does by default). The message means those binaries weren't found in PATH inside the container.

---

## Run on Kubernetes

This repo contains `k8s/deployment.yaml` which includes a Deployment and a NodePort Service. The deployment references image `wisecow:latest` by default — if you're using a local image, you can either load the image into your cluster (minikube, kind) or change the `image:` field to point to a registry image.

1) If using a local cluster where Docker images from the host are visible (e.g. `minikube` with `minikube image load` or `kind` with `kind load docker-image`), either:

- Tag and load image to cluster (minikube example):
```bash
docker build -t wisecow:local .
minikube image load wisecow:local
# then update k8s/deployment.yaml image to wisecow:local OR change imagePullPolicy to IfNotPresent
kubectl apply -f k8s/deployment.yaml
```

- Or push to remote registry and update `k8s/deployment.yaml` to use `your-registry/wisecow:tag` then `kubectl apply -f k8s/deployment.yaml`.

2) Apply manifest
```bash
kubectl apply -f k8s/deployment.yaml
kubectl get pods,svc -l app=wisecow
```

3) If using NodePort you can reach the app through any cluster node on the nodePort. Example (minikube):
```bash
minikube service wisecow-service --url
# or port-forward
kubectl port-forward svc/wisecow-service 4499:4499
# then open http://localhost:4499
```

Notes on images and clusters
- If your cluster can't access local Docker images, push to a registry (Docker Hub, GitHub Packages, GCR, ECR, etc.).
- For a production-ready deployment you'd want to replace the naive `nc`-based server with a proper HTTP server, add readiness/liveness probes that exercise the HTTP stack, and secure traffic (TLS) with an Ingress or Service mesh.

---

## How the server works (brief)

`wisecow.sh` is intentionally tiny and uses simple tools to implement HTTP-like behavior:

- Creates a named pipe `response` (FIFO).
- Uses `nc -lN 4499` to listen for incoming TCP connections.
- When a connection arrives, it reads the request line(s), runs `fortune` to generate a quote, pipes that into `cowsay`, and writes a minimal `HTTP/1.1 200` response with an HTML `<pre>` body containing the ASCII cow.

This is intentionally minimal and fragile for learning/demo purposes. It is not suitable for production as-is.

---

## Troubleshooting

- Container exits with `/usr/bin/env: 'bash\r'`: line-ending issue. The Dockerfile contains a fix but if you edit files on Windows you may need to ensure LF endings or rebuild after converting.
- Container prints `Install prerequisites.` on startup: the script didn't find `fortune` or `cowsay` on PATH. Confirm the Dockerfile installed `fortune-mod` and `cowsay` and that they are available in `/usr/games` (Dockerfile creates symlinks if needed).
- `curl` returns non-200 or timeout: check `docker logs wisecow_local` and ensure the container is up (`docker ps`). The server uses `nc -lN` which accepts one connection at a time in a simple loop; retries are fast but transient failures may appear during startup.

---

## Example health check and helper scripts

- Use `scripts/app_health_checker.sh` to check HTTP 200. Example:
```bash
./scripts/app_health_checker.sh http://localhost:4499/
```

- `scripts/system_health_monitor.sh` is an example system monitor that writes alerts to `/var/log/system_health.log` (requires appropriate permissions if you actually run it).

---

## CI / image publishing (recommended)

You can create a GitHub Actions workflow that builds the image and pushes to a registry on push to `main`. A simple plan:

1. Build the image using `docker/build-push-action`.
2. Tag and push to a registry (Docker Hub, GHCR) with secrets for registry credentials.
3. Optionally run a smoke test by starting the container in the runner and curling the endpoint.

If you'd like, I can add a ready-to-use `.github/workflows/ci.yml` file to this repo.

---

## License

See `LICENSE` in the repository root.

---

## Contact / next steps

If you'd like I can:

- Add a `docker-compose.yml` for easy local startup.
- Add a GitHub Actions workflow to build & push images.
- Deploy the app into a local Kubernetes cluster (minikube/kind) and confirm traffic works.
- Harden the app (replace `nc` server with a tiny Python/Node HTTP server) so it behaves like a typical web app.

If you want any of the above, tell me which and I will implement it.

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
