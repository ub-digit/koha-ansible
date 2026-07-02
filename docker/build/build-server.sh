#!/bin/bash
VERSION=1
docker build -t docker.ub.gu.se/koha-base:server-${VERSION} -f dockerfiles/Dockerfile.server .
docker push docker.ub.gu.se/koha-base:server-${VERSION}
