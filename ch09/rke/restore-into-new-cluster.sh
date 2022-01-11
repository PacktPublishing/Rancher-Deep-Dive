#!/bin/bash
if [[ -z $1 ]]
then
  echo "Missing snapshot name"
  exit 1
fi

echo "Starting docker..."
for node in $(cat cluster.yml | grep ' address:' | awk '{print $3}')
do
  ssh root@"$node" "systemctl start docker"
done

echo "Cleaning cluster..."
for node in $(cat cluster.yml | grep ' address:' | awk '{print $3}')
do
  echo "Moving etcd snapshots to ~/..."
  ssh root@"$node" "mv /opt/rke/etcd-snapshots/ /opt/rke/etcd-snapshots-bk/"
  echo "Running cleanup script..."
  ssh root@"$node" "curl https://gist.githubusercontent.com/mattmattox/56c34f3efb07bdef5e75624f2478f163/raw/352785aa1c66c65622bd19b7552fffafd332f03f/extended-cleanup-rancher2.sh | bash"
done

echo "Rolling docker restart..."
for node in $(cat cluster.yml | grep ' address:' | awk '{print $3}')
do
  echo "Node $node"
  ssh root@"$node" "systemctl restart docker"
  echo "Waiting for docker is to start..."
  while ! ssh root@"$node" "docker ps"
  do
    echo "Sleeping..."
  done
done

echo "rke etcd restore..."
rke etcd snapshot-restore --name $1

echo "Fixing tokens..."
for namespace in kube-system cattle-system ingress-nginx
do
  echo "namespace: $namespace"
  for token in $(kubectl --kubeconfig kube_config_cluster.yml get secret -n $namespace | grep 'kubernetes.io/service-account-token' | awk '{print $1}')
  do
    kubectl --kubeconfig kube_config_cluster.yml delete secret -n $namespace $token
  done
done

echo "Fixing canal..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n kube-system -l k8s-app=canal -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n kube-system delete --grace-period=0 --force $pod
done

echo "Fixing coredns..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n kube-system -l k8s-app=kube-dns -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n kube-system delete --grace-period=0 --force $pod
done

echo "Fixing coredns-autoscaler..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n kube-system -l k8s-app=coredns-autoscaler -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n kube-system delete --grace-period=0 --force $pod
done

echo "Fixing metrics-server..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n kube-system -l k8s-app=metrics-server -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n kube-system delete --grace-period=0 --force $pod
done

echo "Fixing rke jobs..."
for job in $(kubectl --kubeconfig kube_config_cluster.yml get job -n kube-system -o name | grep rke-)
do
  kubectl --kubeconfig kube_config_cluster.yml -n kube-system delete --grace-period=0 --force $job
done

echo "Fixing nginx-ingress..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n ingress-nginx -l app=ingress-nginx -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n ingress-nginx delete --grace-period=0 --force $pod
done

echo "Fixing rancher..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n cattle-system -l app=rancher -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n cattle-system delete --grace-period=0 --force $pod
done

echo "Fixing cattle-node-agent..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n cattle-system -l app=cattle-agent -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n cattle-system delete --grace-period=0 --force $pod
done

echo "Fixing cattle-cluster-agent..."
for pod in $(kubectl --kubeconfig kube_config_cluster.yml get pods -n cattle-system -l app=cattle-cluster-agent -o name)
do
  kubectl --kubeconfig kube_config_cluster.yml -n cattle-system delete --grace-period=0 --force $pod
done

echo "Rolling docker restart..."
for node in $(cat cluster.yml | grep ' address:' | awk '{print $3}')
do
  echo "Node $node"
  ssh root@"$node" "systemctl restart docker"
  echo "Waiting for etcd is to start..."
  while ! ssh root@"$node" "docker inspect -f '{{.State.Running}}' etcd"
  do
    echo "Sleeping..."
  done
  sleep 5
done

echo "Running rke up..."
rke up