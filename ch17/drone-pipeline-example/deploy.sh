#!/bin/bash

if [[ "$1" == 'dev' ]];
then
  namespace='portal-dev'
  imagetag=${BUILD_NUMBER}
  annotate='c-m-gt566p9p:p-dfqlm'
  label='p-dfqlm'
  purge=false
  dbreplicas=3
  ingress='portal-dev.example.local'
elif [[ "$1" == 'stg' ]];
then
  namespace='portal-stg'
  imagetag=${BUILD_NUMBER}
  annotate='c-m-8kd54qrg:p-qdwdk'
  label='p-qdwdk'
  purge=false
  dbreplicas=3
  ingress='portal-staging.example.local'
elif [[ "$1" == 'prd' ]];
then
  namespace='portal'
  imagetag=${BUILD_NUMBER}
  annotate='c-m-8kd54qrg:p-qdwdk'
  label='p-qdwdk'
  purge=false
  dbreplicas=5
  ingress='portal.example.local'
else
  namespace=portal-${DRONE_BUILD_NUMBER}
  imagetag=${DRONE_BUILD_NUMBER}
  annotate='c-m-9ldt7ts5:p-4pxc8'
  label='p-4pxc8'
  purge=true
  dbreplicas=3
  ingress=`echo "portal-master-${DRONE_BUILD_NUMBER}.example.local"`
fi

echo "Deploying to namespace: ${namespace}"
echo "Image tag: ${imagetag}"
echo "Annotate: ${annotate}"
echo "Label: ${label}"
echo "Purge: ${purge}"
echo "DB Replicas: ${dbreplicas}"

bash /usr/local/bin/init-kubectl

echo "Creating namespace"
kubectl create ns ${namespace} --dry-run=client -o yaml | kubectl apply -f -
kubectl annotate ns ${namespace} --overwrite=true field.cattle.io/projectId=${annotate}
kubectl label ns ${namespace} --overwrite=true field.cattle.io/projectId=${label}
kubectl label ns ${namespace} team=Mattox --overwrite
kubectl label ns ${namespace} app=portal --overwrite
kubectl label ns ${namespace} ns-purge=${purge} --overwrite

echo "Creating registry secret"
kubectl -n ${namespace} create secret docker-registry harbor-registry-secret \
--docker-server=harbor.support.tools \
--docker-username=${DOCKER_USERNAME} \
--docker-password=${DOCKER_PASSWORD} \
--dry-run=client -o yaml | kubectl apply -f -

echo "Deploying MariaDB"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install mariadb bitnami/mariadb-galera \
--namespace ${namespace} \
--set image.debug=true \
--set image.tag=10.5.15 \
--set global.storageClass=longhorn \
--set rootUser.password=${dbpassword} \
--set db.user=${dbuser} \
--set db.password=${dbpassword} \
--set db.name=portal \
--set galera.mariabackup.password=mariabackup \
--set galera.mariabackup.user=mariabackup \
--set replicaCount=${dbreplicas}

echo "Waiting for MariaDB to come online..."

counter=0
until kubectl run db-test --rm --tty -i --restart='Never' --namespace ${namespace} --image docker.io/bitnami/mariadb-galera:10.5.15 -- mysql -h mariadb-mariadb-galera -u${dbuser} -p${dbpassword} portal -e '/* ping */ SELECT 1'
do
  ((counter++))
  if [ $counter -gt 60 ]
  then
    break
  else
    echo "Try $counter"
    sleep 1
  fi
done

echo "Deploying Portal"
helm upgrade --install portal ./chart \
--namespace ${namespace} \
-f ./chart/values.yaml \
--set image.tag=${DRONE_BUILD_NUMBER} \
--set ingress.host=${ingress}