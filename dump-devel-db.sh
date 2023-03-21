#!/bin/bash

# Connect to docker-compose mariadb container
SERVICE_NAME="mariadb"
COMPOSE_CMD="docker-compose -f docker-compose.yml -f docker-compose.devel.yml"

# Dump the database using mysqldump, from database koha_koha to initial-db.sql
# using the root user and password root_password
$COMPOSE_CMD exec $SERVICE_NAME mysqldump -u root -proot_password koha_koha > initial-db.sql
