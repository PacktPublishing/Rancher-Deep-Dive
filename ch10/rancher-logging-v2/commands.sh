helm repo add rancher-charts https://charts.rancher.io
helm repo update

helm upgrade --install rancher-logging-crd -n cattle-logging-system rancher-charts/rancher-logging-crd
helm upgrade --install rancher-logging -n cattle-logging-system rancher-charts/rancher-logging