#!/bin/bash

render() {
sedStr="
  s!%%NODE_VERSION%%!$version!g;
"

sed -r "$sedStr" $1
}

docker login -u $DOCKER_USER -p $DOCKER_PASS

versions=(0.10.47 4.6.0 5.5.0 6.10.0 6.7.0 7.3.0 7.4.0 7.9.0 8.0.0)
for version in ${versions[*]}; do
  mkdir -p .build/$version
  render Dockerfile.template > .build/$version/Dockerfile
  docker build -t $DOCKER_REPO:$version .build/$version
  docker push $DOCKER_REPO:$version
done
