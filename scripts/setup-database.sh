#!/bin/bash

## Flow
# 1. setup required env variables (edit as you need)
# 2. Run liquibase command to setup roles, schema, tables (scans the exported env var)

### Migration to create roles, schema, tables
# Liquibase CLI Env Var
export DB_URL="jdbc:postgresql://<host>:<port>/<database_name>"
export DB_USER=
export DB_PASSWORD=
# Changelog Env Var
export USER_1_PASSWORD=
# Run Command
liquibase update \
    --contexts="\!filter1,filter2" \
    --labels="label1 or label2" \
    --changelog-file=./changelogs/databases/database.yaml \
    --url="$DB_URL" \
    --username="$DB_USER" \
    --password="$DB_PASSWORD" \
    --log-level=INFO

# liquibase clear-checksums \
#       --url="$DB_URL" \
#     --username="$DB_USER" \
#     --password="$DB_PASSWORD" \
#     --log-level=INFO
