DATABASE=$1
sudo -u postgres psql -c "DROP DATABASE IF EXISTS $DATABASE"