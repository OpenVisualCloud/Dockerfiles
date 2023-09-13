#!/bin/bash

# start nginx
sudo nginx -c /home/${USERNAME}/nginx/nginx.conf

# start mysql
sudo /tmp/setup_db_ghost.sh
sudo service mysql start
sleep 2

# launch ghost
# sudo NODE_ENV=production NODE_REAL_ENV=production node -r ./hack.js ./current/index.js &

# launch client
# ab -r -n 20000 -c 50 https://localhost:8080/

# wrk -t50 -c50 -d30s https://localhost:8080/
