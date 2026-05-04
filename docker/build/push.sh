#!/bin/bash
source .env 

docker push docker.ub.gu.se/koha-elasticsearch:${ELASTICSEARCH_VERSION}
docker push docker.ub.gu.se/koha:${GIT_REVISION}
docker push docker.ub.gu.se/koha-rabbitmq:${RABBITMQ_VERSION}
