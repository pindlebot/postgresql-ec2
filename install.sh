#!/usr/bin/env bash

echo SECRET_TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) > /tmp/secret

cd /tmp
yum list postgresql10-libs || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-libs-10.5-1PGDG.rhel7.x86_64.rpm
yum list postgresql10-10.5 || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-10.5-1PGDG.rhel7.x86_64.rpm
yum list postgresql10-contrib || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-contrib-10.5-1PGDG.rhel7.x86_64.rpm
yum list postgresql10-devel || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-devel-10.5-1PGDG.rhel7.x86_64.rpm
yum list postgresql10-server || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-server-10.5-1PGDG.rhel7.x86_64.rpm
yum list postgresql10-test || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-test-10.5-1PGDG.rhel7.x86_64.rpm
yum list postgresql10-pltcl || yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-pltcl-10.5-1PGDG.rhel7.x86_64.rpm

/usr/pgsql-10/bin/postgresql-10-setup initdb
systemctl enable postgresql-10
systemctl start postgresql-10

# sed -i 's|all                                     ident|all                                     trust|' /var/lib/pgsql/10/data/pg_hba.conf
# sed -i 's|127.0.0.1/32|0.0.0.0/0|' /var/lib/pgsql/10/data/pg_hba.conf
# sed -i 's|ident|   md5|' /var/lib/pgsql/10/data/pg_hba.conf
curl -o /var/lib/pgsql/10/data/pg_hba.conf https://raw.githubusercontent.com/unshift/postgresql-ec2/master/pg_hba.conf
sed -i 's|#listen_addresses = \x27localhost\x27|listen_addresses = \x27*\x27|' /var/lib/pgsql/10/data/postgresql.conf
sed -i 's|#port = 5432|port = 5432|' /var/lib/pgsql/10/data/postgresql.conf
sed -i 's|#shared_preload_libraries = \x27\x27|shared_preload_libraries = \x27pg_cron\x27|' /var/lib/pgsql/10/data/postgresql.conf
echo "cron.database_name = 'postgres'" >> /var/lib/pgsql/10/data/postgresql.conf

systemctl restart postgresql-10
source /tmp/secret
psql -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD '$SECRET_TOKEN';"

export PATH=$PATH:/usr/pgsql-10/bin/

yum install -y git
yum install -y libcurl-devel
yum install -y gcc

cd /tmp && git clone https://github.com/pramsey/pgsql-http.git
cd pgsql-http && make && make install

cd /tmp && git clone https://github.com/citusdata/pg_cron.git
cd pg_cron && make && make install
systemctl restart postgresql-10