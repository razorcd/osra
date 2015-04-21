#to build and start container
# sudo docker build -t ubuntu-osra .
# sudo docker run -p 3000:3000 -d ubuntu-osra


FROM ubuntu:14.04
MAINTAINER razor razorcd@yahoo.com

#update app list
RUN sudo apt-get update

#install
RUN sudo apt-get install -y build-essential curl git-core libpq-dev nodejs
# RUN sudo apt-get install python -y


#rvm and ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# RUN rvm install ruby-2.2.0
RUN rvm reload
CMD source /etc/profile
CMD source /usr/local/rvm/scripts/rvm
# RUN ["/bin/bash", "-l", "-c", "rvm use 2.2.0 --default" ]
RUN ["/bin/bash", "-l", "-c", "gem install bundler --no-ri --no-rdoc"]


#postgresql
#sudo apt-get install -y language-pack-en-base
#sudo apt-get install -y language-pack-ro-base
RUN sudo apt-get install -y postgresql-9.3
RUN sudo apt-get install -y postgresql-server-dev-9.3
RUN sudo apt-get install -y postgresql-contrib-9.3

#postfres conf
RUN sudo cp /etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf.bk
RUN sudo sed -i -e 's/local\s\+all\s\+postgres\s\+peer/local all postgres trust/g' /etc/postgresql/9.3/main/pg_hba.conf
# RUN echo "host    all             all             0.0.0.0/0 trust" >> /etc/postgresql/$PG_VERSION/main/pg_hba.conf
# RUN sudo /etc/init.d/postgresql start
# CMD ["service", "postgresql", "start"]


#install ssh-server

#clone git repo
#RUN git clone https://github.com/AgileVentures/osra

#app
RUN sudo mkdir /osra
WORKDIR /osra
ADD . /osra

RUN ["/bin/bash", "-l", "-c", "bundle install --without development test"]

EXPOSE 3000 22

CMD ["sh", "start_rails.sh"]
# CMD ["/bin/bash", "-lc", "start_rails.sh"]
