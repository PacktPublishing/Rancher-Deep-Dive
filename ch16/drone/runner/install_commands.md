```bash
## Create drone namespace
kubectl create ns drone-runner --dry-run=client | kubectl apply -f

## Setup helm repo
helm repo add drone https://charts.drone.io
helm repo update

## Install the chart
helm install kube-runner drone/drone -n drone-runner \
--set env.DRONE_SERVER_HOST=drone.example.com \
--set env.DRONE_SERVER_PROTO=https \
--set env.DRONE_RPC_SECRET=bea26a2221fd8090ea38720fc445eca6
```