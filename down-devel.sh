#!/bin/bash

export KOHA_REPO=/home/stefan/work/koha/koha/Koha-devel

docker-compose -f docker-compose.yml -f docker-compose.devel.yml down