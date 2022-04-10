```bash
## Setup helm repo
helm repo add drone https://charts.drone.io
helm repo update

## Upload ssl cert
kubectl -n drone create secret tls ssl-cert --key="tls.key" --cert="tls.crt"

## Create RPC Secret
openssl rand -hex 16
bea26a2221fd8090ea38720fc445eca6

## Install the chart
helm install drone-server drone/drone -n drone \
--set ingress.enabled=true \
--set ingress.hosts[0].host=drone.example.com \
--ingress.tls.[0].hosts=drone.example.com \
--set ingress.tls.[0].secretName=ssl-cert \
--set persistentVolume.enabled=true \
--set persistentVolume.storageClass=longhorn \
--set env.DRONE_SERVER_HOST=drone.example.com \
--set env.DRONE_SERVER_PROTO=https \
--set env.DRONE_DATABASE_DRIVER=postgres \
--set env.DRONE_DATABASE_DATASOURCE="postgres://drone:drone@drone-db:5432/drone?sslmode=disable" \
--set env.DRONE_RPC_SECRET=bea26a2221fd8090ea38720fc445eca6 \
--set env.DRONE_GIT_ALWAYS_AUTH=true \
--set env.DRONE_GITHUB_CLIENT_ID=your-id \
--set env.DRONE_GITHUB_CLIENT_SECRET=github-secret \
--set env.DRONE_USER_CREATE=username:Your-GitHub-Username,admin:true
--set env.DRONE_USER_FILTER=Your-GitHub-ORG
```