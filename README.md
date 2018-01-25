# Auth-Rails

Authorization backend as a microservice to be used with other microservices in Docker

Technologies used:

- JWT
- Rails API
- PostgresSQL

Tested using:
- RSpec


## As an Engine

Required Steps:

1. Remove `protect_from_forgery` from host app

app/controllers/application_controller.rb

```
class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  ...
end
```

2. Add HMAC_SECRET

config/secrets.yml

```
hmac_secret: my$ecretK3y
```

3. Load the migrations to host app

```
$ rails railties:install:migrations
$ rake db:migrate
```
