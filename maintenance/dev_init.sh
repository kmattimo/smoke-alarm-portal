#!/bin/bash

#if c
echo "Run me from the project root!"

if [ -f "config.js" ]
then  
  echo "found existing config.js"
else 
  echo "copying from config.js.tmpl"
  cp config.js.tmpl config.js
fi

if [ -f "config/config.json" ]
then  
  echo "found existing config.json"
else 
  echo "copying from config.json.tmpl"
  cp config/config.json.tmpl config/config.json
fi

if [ -f "config/recipients.sql" ]
then  
  echo "found existing recipients.sql"
else 
  echo "copying from config.json.tmpl"
  cp config/recipients.sql.tmpl config/recipients.sql
fi

exit

echo "Enter password for website admin user"
read -p "admin password: " pwd
echo "Adding user"

# "INSERT INTO \"User\" (\"username\",\"password\",\"isActive\",\"createdAt\",\"updatedAt\") VALUES ( 'admin', crypt('hunter2', gen_salt('bf')), 'yes',now(),now());"
#password?? 

psql -U postgres << EOF
  DROP DATABSE IF EXISTS smokealarm_development
  postgres=# CREATE DATABASE smokealarm_development;
EOF

psql -U postgres -d smokealarm_development  << EOF

  CREATE EXTENSION pgcrypto;
  INSERT INTO "User" ("username","password","isActive","createdAt","updatedAt") VALUES ( 'admin', crypt('$pwd', gen_salt('bf')), 'yes',now(),now());
EOF

