FROM ubuntu:14.04

# ENTRYPOINT["ping"]




###################################################################################33

#add your ssh key to server
ssh-copy-id deploy@188.166.56.97

#set locales
sudo echo LC_ALL="en_US.UTF-8" >> /etc/environment
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales


#add new user
sudo adduser deploy
sudo adduser deploy sudo
su deploy

#dependencies
sudo apt-get update
sudo apt-get install -y curl
# zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

#create ssh KEY
# mkdir ~/.ssh
# chmod 700 ~/.ssh
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa






#install ruby with rvm
sudo apt-get -y install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.2.0
rvm use 2.2.0 --default


#### rvm installs dependencies:
#Installing required packages: g++, gcc, make, libc6-dev, libreadline6-dev, zlib1g-dev, libssl-dev, libyaml-dev, libsqlite3-dev, sqlite3, autoconf, libgdbm-dev, libncurses5-dev, automake, libtool, bison, pkg-config, libffi-dev
####

#install phantomJS

sudo apt-get install build-essential chrpath libssl-dev libxft-dev
sudo apt-get install libfreetype6 libfreetype6-dev
sudo apt-get install libfontconfig1 libfontconfig1-dev

cd ~
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2

sudo mv $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

#install nodejs
curl --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs

#install capybara
# sudo apt-get install -y libqt5webkit5-dev qtdeclarative5-dev
sudo apt-get install qt5-default libqt5webkit5-dev
gem install capybara-webkit -v '1.4.1'

#install bundler
/bin/bash -l
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler

#instal nginx
sudo apt-get install -y nginx
# sudo update-rc.d nginx defaults
# sudo nano /etc/nginx/nginx.conf    #change user to  deploy
#to check nginx error logs:   sudo tail /var/log/nginx/error.log


#install mysql
sudo apt-get install -y mysql-server mysql-client libmysqlclient-dev

#install postgresql
sudo apt-get install -y postgresql-9.3 libpq-dev
# postgresql-contrib-9.3
# sudo pg_createcluster 9.3 main
# sudo service postgresql restart

sudo su - postgres
createuser --pwprompt
createuser deploy --pwprompt
exit


#create DB
su postgres
psql
alter user postgres  with password 'password';
create database osra_production with owner = postgres;
exit

chage is '/etc/postgresql/9.3/main/pg_hba.conf' :
local   all             postgres                                peer
to
local   all             postgres                                trust
in '/confing/database.yml' add password or   <%= ENV["MYSQL_DB_PASSWORD"] %>


#copy repo
git clone <repo>
cd <repo>
bundle --binstubs
cap install STAGES=production,staging,testing
config Capfile, config/deploy.rb, config/deploy/production.rb














#add new user
sudo apt-get update
sudo apt-get install -y makepasswd
 makepasswd --clearfrom=- --crypt-md5 <<< pass123

sudo useradd -p pass123 -m deploy
sudo useradd -m -p pass123 -s /bin/bash deploy
# sudo adduser deploy
# sudo adduser deploy sudo
# su deploy

#create ssh KEY
mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa



#dependencies
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

#install ruby with rvm
sudo apt-get -y install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.2.0
rvm use 2.2.0 --default


#install bundler
echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler

#instal nginx
sudo apt-get install -y nginx




sudo -n --prompt=pass123 apt-get update
usermod --password pass123 deploy
