#!/bin/bash

set -e

KOHA_SERVICE=koha-devbox
KOHA_HOME=/home/apps/koha-repo
ELASTICSEARCH_SERVICE=elasticsearch
ELASTICSEARCH_DATADIR=data/build/elasticsearch
MARIADB_SERVICE=mariadb
MARIADB_DATADIR=data/build/mariadb
MEMCACHED_SERVICE=memcached

IMAGE_KOHA=devbox:1
IMAGE_ELASTICSEARCH_INTER=elasticsearch:inter1
IMAGE_ELASTICSEARCH_FINAL=elasticsearch:1
IMAGE_MARIADB_FINAL=mariadb:1

sudo rm -Rf "./data/build"
#docker build -t $IMAGE_KOHA .
#docker build -f Dockerfile.elasticsearch -t $IMAGE_ELASTICSEARCH_INTER .

mkdir -p $ELASTICSEARCH_DATADIR
mkdir -p $MARIADB_DATADIR
docker-compose -f docker-compose.yml -f docker-compose.build.yml down
docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d $MARIADB_SERVICE
docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d $ELASTICSEARCH_SERVICE
docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d $MEMCACHED_SERVICE
echo "Waiting for containers to initialize..."
sleep 50
docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d $KOHA_SERVICE

docker-compose exec $KOHA_SERVICE koha-shell koha -c "$KOHA_HOME/misc/search_tools/rebuild_elasticsearch.pl -v -b"
docker-compose exec $KOHA_SERVICE koha-shell koha -c "$KOHA_HOME/misc/search_tools/rebuild_elasticsearch.pl -v -a"

sudo chown -R 1000 $MARIADB_DATADIR
echo "Waiting for elastic commit"
sleep 70

docker-compose down
docker build -f Dockerfile.elasticsearch.final -t $IMAGE_ELASTICSEARCH_FINAL .
docker build -f Dockerfile.mariadb.final -t $IMAGE_MARIADB_FINAL .
docker-compose down
