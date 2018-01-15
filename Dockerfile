FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ARG INSTALL_PATH=/app

ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

# Create a directory where our app will be placed
RUN mkdir -p $INSTALL_PATH

# Change directory so that our commands run inside this new directory
WORKDIR $INSTALL_PATH

# Copy dependency definitions
# IMPORTANT:: Need to turn off if starting new app
COPY Gemfile $INSTALL_PATH/Gemfile
COPY Gemfile.lock $INSTALL_PATH/Gemfile.lock
RUN bundle install --without development test

COPY . $INSTALL_PATH

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
