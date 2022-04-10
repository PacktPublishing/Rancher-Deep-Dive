```bash
## Setup helm repo
helm repo add harbor https://helm.goharbor.io
helm repo update

## Create a namespace
kubectl create ns harbor --dry-run=client | kubectl apply -f

## Upload ssl cert
kubectl -n harbor create secret tls ssl-cert --key="tls.key" --cert="tls.crt"

## Install the chart
helm upgrade --install harbor harbor/harbor -n harbor \
--set expose.type=ingress \
--set expose.tls.secret.secretName=ssl-cert \
--set expose.tls.secret.notarySecretName=ssl-cert \
--set expose.ingress.hosts.core=harbor.example.com \
--set expose.ingress.hosts.notary=harbor-notary.example.com \
--set persistence.enabled=true \
--set persistence.persistentVolumeClaim.registry.storageClass=longhorn \
--set persistence.persistentVolumeClaim.chartmuseum.storageClass=longhorn \
--set persistence.persistentVolumeClaim.jobservice.storageClass=longhorn \
--set persistence.persistentVolumeClaim.database.storageClass=longhorn \
--set persistence.persistentVolumeClaim.redis.storageClass=longhorn \
--set persistence.persistentVolumeClaim.trivy.storageClass=longhorn
```