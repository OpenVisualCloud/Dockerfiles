#!/bin/bash

# Step 1: Initialize MySQL (if not already initialized)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL..."
    mysqld --initialize-insecure
    echo "MySQL initialized."
fi

# Step 2: Start the MySQL server
sudo service mysql start

# Step 3: Reset root password and authentication method (in case it's necessary)
mysql -u root --skip-password -e "FLUSH PRIVILEGES"
mysql -u root --skip-password -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND host = 'localhost'"
mysql -u root --skip-password -e "SET PASSWORD FOR 'root'@'localhost' = ''"
mysql -u root --skip-password -e "FLUSH PRIVILEGES"
mysql -u root --skip-password -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
mysql -u root --skip-password -e "FLUSH PRIVILEGES"

# Step 4: Import the database dump
USERNAME="ghost"
DUMP_PATH="/home/${USERNAME}/ghost.dump"
if [ -f "${DUMP_PATH}" ]; then
    mysql -u root --skip-password < "${DUMP_PATH}"
    echo "Database imported from ${DUMP_PATH}."
else
    echo "Error: Dump file ${DUMP_PATH} not found."
fi

# Step 5: Stop the MySQL server (optional, depending on your requirements)
sudo service mysql stop

echo "Script execution completed."
