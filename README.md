# Auth-Rails

Authorization backend as a microservice to be used with other microservices in Docker

Technologies used:

- JWT
- Rails API 5.2
- PostgresSQL

Tested using:
- RSpec


## As an Engine

Required Steps:

1. Generate Rails secret credential (hmac_secret)
 - in host app
 - in api_rails engine (for running tests)

```
EDITOR=vim rails credentials:edit

hmac_secret: my$ecretK3y
```

2. Load the migrations to host app

```
$ rails railties:install:migrations
$ rake db:migrate
```

3. Add engine to host Gemfile

```
gem 'auth_rails', :path => "engines/auth-rails"
```

4. Mount the engine routes

```
mount AuthRails::Engine, :at => "/auth"
```

5. Enjoy!

## Aside: Run the tests

```
./test.sh
```