#!/bin/sh

echo "Setting docker environment"
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD harbor.example.local

cd ./microservices
ROOTPWD=`pwd`

for dir in `ls -d *`
do
  echo "Working on $dir"
  cd ./${dir}/

  echo "Building..."
  if ! docker build -t harbor.example.local/example/${dir}:${DRONE_BUILD_NUMBER} --build-arg REACT_APP_URL="/api" -f Dockerfile .
  then
    echo "Docker build failed"
    exit 127
  fi
  if ! docker push harbor.example.local/example/${dir}:${DRONE_BUILD_NUMBER}
  then
    echo "Docker push failed"
    exit 126
  fi

  cd $ROOTPWD
done