#!/bin/bash

render() {
sedStr="
  s!%%NODE_VERSION%%!$version!g;
"

sed -r "$sedStr" $1
}

docker login -u $DOCKER_USER -p $DOCKER_PASS

versions=(0.10 4.x 4.8.4 5.x 6.x 7.x 8.x)
for version in ${versions[*]}; do
  mkdir -p .build/$version
  cp jenkins-slave .build/$version
  render Dockerfile.template > .build/$version/Dockerfile
  docker build -t $DOCKER_REPO:$version-jnlp .build/$version
  docker push $DOCKER_REPO:$version-jnlp
done
