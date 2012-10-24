# Examples

# MongoDB
# echo "INFO: Configuring 10gen repo"
# apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
# 
# cat >> /etc/apt/sources.list.d/10gen.list <<EOF
# deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
# EOF
# 
# echo "INFO: Updating APT repo"
# apt-get update
# 
# echo "INFO: Installing mongodb-10gen"
# apt-get install mongodb-10gen -y


# echo "INFO: Installing ImageMagick"
# apt-get install libmagickwand-dev imagemagick -y

# echo "INFO: Installing V8 javascript runtime provided by node.js"
# aptitude install nodejs -y

# # gems
# gem install bundler chef ruby-shadow --no-ri --no-rdoc

# echo "INFO: Deploying the application"
# su -l -c 'cd /home/vagrant/app_name && bundle install --path vendor/bundle' vagrant

# echo "INFO: Installing additional packages"
# aptitude install -y libcurl4-openssl-dev

# echo "INFO: Configuring Postgresql"
# # su -l -c 'touch ~/.pgpass' postgres
# # su -l -c 'chmod 600 ~/.pgpass' postgres
# # su -l -c 'echo -e "# hostname:port:database:username:password\n*:*:*:app_name:password\n*:*:*:demouser:password" >> ~/.pgpass' postgres
# su -l -c 'createuser -s --no-password app_name' postgres                      # you'll have to set the user password later
# su -l -c 'createdb -O app_name -E UTF8 app_name_development' postgres
# su -l -c 'createdb -O app_name -E UTF8 app_name_test' postgres
# su -l -c 'createdb -O app_name -E UTF8 app_name_production' postgres
# echo -e 'host\tall\tall\t0.0.0.0/0\tmd5' >> /etc/postgresql/9.1/main/pg_hba.conf
# service postgresql restart


# More examples

# #!/usr/bin/env bash
# apt-get -y update

# # Rails Ready packages
# apt-get -y install \
#     curl build-essential clang \
#     bison openssl zlib1g \
#     libxslt1.1 libssl-dev libxslt1-dev \
#     libxml2 libxml2-dev libffi6 \
#     libffi-dev libyaml-dev \
#     libxslt-dev autoconf libc6-dev \
#     libreadline6 libreadline6-dev git-core \
#     zlib1g-dev libcurl4-openssl-dev libtool \

# # mysql
# apt-get -y install libmysqlclient-dev

# # postgresql
# apt-get -y install libpq-dev

# # sqlite3
# apt-get -y install libsqlite3-0 libsqlite3-dev sqlite3

# # libyaml
# cd /tmp
# wget -q http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
# tar xzvf yaml-0.1.4.tar.gz
# cd yaml-0.1.4
# ./configure --prefix=/usr/local
# make
# make install

# # ruby
# cd /tmp
# wget -q ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
# tar -xvzf ruby-1.9.3-p194.tar.gz
# cd ruby-1.9.3-p194
# ./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
# make
# make install
