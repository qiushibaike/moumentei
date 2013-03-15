sudo apt-get install -y mercurial wget htop
sudo apt-get install -y rabbitmq-server memcached mysql-server libmysqlclient-dev imagemagick
sudo apt-get install -y redis-server 
# install REE
sudo apt-get -y install zlib1g-dev libssl-dev libreadline-dev build-essential patch
sudo chmod a+w /tmp
cd /tmp
wget -c http://rubyforge.org/frs/download.php/68719/ruby-enterprise-1.8.7-2010.01.tar.gz
tar zxvf ruby-enterprise-1.8.7-2010.01.tar.gz
cd ruby-enterprise-1.8.7-2010.01
sudo ./installer -a /opt/ruby --no-dev-docs
sudo /opt/ruby/bin/gem i passenger --no-ri --no-rdoc
cd ..
# install nginx
sudo apt-get -y install libpcre3-dev

wget -c http://nginx.org/download/nginx-0.8.35.tar.gz
tar zxvf nginx-0.8.35.tar.gz
cd nginx-0.8.35
sudo /opt/ruby/bin/passenger-install-nginx-module --auto --prefix=/opt/nginx --nginx-source-dir=`pwd` --extra-configure-flags="--with-http_stub_status_module"
#./configure --prefix=/opt/nginx --with-http_stub_status_module #--with-cpu-opt=pentium4 --with-file-aio
#make 
#sudo make install
# install haproxy
cd ..

wget -c http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.3.tar.gz
tar zxvf haproxy-1.4.3.tar.gz
cd haproxy-1.4.3
make TARGET=linux26
sudo cp haproxy /opt/nginx/sbin
cd ..

#--------------------------
# chef
# rubygems 1.3.6
export PATH=/opt/ruby/bin:$PATH
sudo apt-get install -y libsasl2-dev # for libmemcached

sudo /opt/ruby/bin/gem update --system --no-ri --no-rdoc
sudo /opt/ruby/bin/gem i gemcutter --no-ri --no-rdoc
sudo /opt/ruby/bin/gem i echoe thin amqp memcached ohm paperclip thinking-sphinx rack-cache newrelic_rpm exceptional --no-ri --no-rdoc
sudo /opt/ruby/bin/gem install rubyist-aasm famoseagle-carrot --source http://gems.github.com
sudo /opt/ruby/bin/gem install mislav-will_paginate --version "~> 2.3.2" --source http://gems.github.com
cd ..
sudo mkdir -p /home/www/qqq
sudo chmod a+w /home/www/qqq
cd /home/www/qqq
hg clone ssh://moumentei.com/~/qqq current
cd current
mkdir log
mkdir tmp
chmod a+w log tmp
cp config/database.default.yml config/database.yml
sudo rm /opt/nginx/conf/nginx.conf
sudo ln -s `pwd`/vendor/nginx.conf /opt/nginx/conf/nginx.conf
#sudo apt-get -y install libxml2-dev libxslt1-dev couchdb rabbitmq-server
#gem i merb-core merb-assets merb-helpers merb-slices merb-haml merb-param-protection \
#      haml coderay \
#      webrat \
#      thin json uuidtools
