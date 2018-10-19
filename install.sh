#!/bin/bash -v

SECRET_TOKEN=$(openssl rand -hex 20)
echo "SECRET_TOKEN=$SECRET_TOKEN" > /tmp/secret

yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-libs-10.5-1PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-10.5-1PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-contrib-10.5-1PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-devel-10.5-1PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-server-10.5-1PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-test-10.5-1PGDG.rhel7.x86_64.rpm
yum install -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/postgresql10-pltcl-10.5-1PGDG.rhel7.x86_64.rpm

/usr/pgsql-10/bin/postgresql-10-setup initdb
systemctl enable postgresql-10

curl -o /var/lib/pgsql/10/data/pg_hba.conf https://raw.githubusercontent.com/unshift/postgresql-ec2/master/pg_hba.conf
sed -i 's|#listen_addresses = \x27localhost\x27|listen_addresses = \x27*\x27|' /var/lib/pgsql/10/data/postgresql.conf
sed -i 's|#port = 5432|port = 5432|' /var/lib/pgsql/10/data/postgresql.conf
sed -i 's|#shared_preload_libraries = \x27\x27|shared_preload_libraries = \x27pg_cron\x27|' /var/lib/pgsql/10/data/postgresql.conf
echo "cron.database_name = 'postgres'" >> /var/lib/pgsql/10/data/postgresql.conf

systemctl start postgresql-10
psql -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD '$SECRET_TOKEN';"

export PATH=$PATH:/usr/pgsql-10/bin/

cd /tmp && git clone https://github.com/pramsey/pgsql-http.git
cd pgsql-http && make && make install

cd /tmp && git clone https://github.com/citusdata/pg_cron.git
cd pg_cron && make && make install

cd /tmp && git clone https://github.com/michelp/pgjwt.git
cd pgjwt && make && make install

cd /tmp && git clone https://github.com/unshift/pg_gen_uid.git
cd pg_gen_uid && make && make install

systemctl restart postgresql-10
