#!/bin/bash
USER=${MYSQL_USERNAME:-admin}
PASS=${MYSQL_PASSWORD:-$(pwgen -s -1 16)}
DB=${MYSQL_DBNAME:-}

# Start MySQL service
/usr/bin/mysqld_safe &
while ! nc -vz localhost 3306; do sleep 1; done

# Create user
echo "Creating user: \"$USER\"..."
/usr/bin/mysql -uroot -e "CREATE USER '$USER'@'%' IDENTIFIED BY '$PASS'"
/usr/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%' WITH GRANT OPTION"

# Create dabatase
if [ ! -z "$DB" ]; then
    echo "Creating database: \"$DB\"..."
    /usr/bin/mysql -uroot -e "CREATE DATABASE $DB"
fi

# Stop MySQL service
mysqladmin -uroot shutdown
while nc -vz localhost 3306; do sleep 1; done

echo "========================================================================"
echo "MySQL User: \"$USER\""
echo "MySQL Password: \"$PASS\""
if [ ! -z $DB ]; then
    echo "MySQL Database: \"$DB\""
fi
echo "========================================================================"

rm -f /.firstrun
