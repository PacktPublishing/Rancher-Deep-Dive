```bash
## Create a ServiceAccount and assign it ClusterAdmin permissions
kubectl -n kube-system create serviceaccount drone
kubectl create clusterrolebinding --clusterrole=cluster-admin --serviceaccount=kube-system:drone drone
TOKENNAME=`kubectl -n kube-system get serviceaccount/drone -o jsonpath='{.secrets[0].name}'`
TOKEN=`kubectl -n kube-system get secret $TOKENNAME -o jsonpath='{.data.token}'| base64 --decode`
echo $TOKEN
```
