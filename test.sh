#!/bin/bash

echo "*** Dropping the database ***"
RAILS_ENV=test rake db:drop --trace
echo "*** Creating the database ***"
RAILS_ENV=test rake db:create --trace
echo "*** Loading the DB Schema ***"
RAILS_ENV=test rake db:schema:load --trace
echo "*** Running RSpec ***"
rspec
