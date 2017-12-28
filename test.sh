#!/bin/bash

echo "*** Creating the database ***"
rake db:create --trace
echo "*** Migrating the database ***"
rake db:migrate --trace
echo "*** Running RSpec ***"
rspec
echo "*** Done! ***"
