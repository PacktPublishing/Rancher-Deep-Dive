helm repo add rancher-charts https://charts.rancher.io
helm repo update

helm upgrade --install rancher-monitoring-crd -n cattle-monitoring-system rancher-charts/rancher-monitoring-crd
helm upgrade --install rancher-monitoring -n cattle-monitoring-system rancher-charts/rancher-monitoring -f values.yaml 