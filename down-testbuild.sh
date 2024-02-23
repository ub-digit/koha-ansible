#!/bin/bash

export KOHA_REPO=/home/stefan/koha-build/Koha-devel

docker-compose -f docker-compose.yml -f docker-compose.testbuild.yml down
