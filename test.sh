#!/bin/bash

echo "*** Dropping existing DB ***"
RAILS_ENV=test rake db:drop --trace
echo "*** Creating the database ***"
RAILS_ENV=test rake db:create --trace
echo "*** Migrating the database ***"
RAILS_ENV=test rake db:migrate --trace
echo "*** Running RSpec ***"
rspec
