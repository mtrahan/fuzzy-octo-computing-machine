#!/bin/sh

sudo apt-get install -y nodejs npm
sudo apt-get install -y postgresql-client
sudo apt-get install -y libpq-dev
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y ruby-dev
sudo apt-get install -y ruby
sudo gem install sqlite3 --no-ri --no-rdoc
sudo gem install rails --no-ri --no-rdoc
