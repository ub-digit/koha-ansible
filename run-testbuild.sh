#!/bin/bash

export KOHA_REPO=/home/stefan/work/koha/Koha-devel

docker-compose -f docker-compose.yml -f docker-compose.testbuild.yml up -d
