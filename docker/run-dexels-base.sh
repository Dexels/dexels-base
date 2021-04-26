#!/bin/sh

startflags="--add-modules java.se "
startflags+="--add-opens java.base/java.net=ALL-UNNAMED "


VERSION="3.3.852-test"
CONTAINER="dexels-base-$VERSION"


docker rm "$CONTAINER"

docker \
    run \
    --name "$CONTAINER" \
    -e startflags="$startflags" \
    -e CLUSTER_USE_DEFAULT_CLASSLOADER="true" \
    -e HAZELCAST_SIMPLE="true" \
    -p "8181:8181" \
    "dexels/dexels-base:$VERSION"

