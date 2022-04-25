```bash
## Create drone namespace
kubectl create ns drone --dry-run=client | kubectl apply -f

## Setup helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami

## Install the chart
helm install drone-db bitnami/postgresql -n drone \
--set global.storageClass=longhorn \
--set global.postgresql.auth.postgresPassword=drone \
--set global.postgresql.auth.username=drone \
--set global.postgresql.auth.password=drone \
--global.postgresql.auth.database=drone
```