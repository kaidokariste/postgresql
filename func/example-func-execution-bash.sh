#!/bin/bash
dbhost="<db-server-name>"
database="<postgres-db-name"

psql -a -U admin -d $database -h $dbhost   << EOF
  select myschema.load_some_data();
EOF
