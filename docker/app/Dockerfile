FROM ruby:2.5.1

ARG ENV
ARG SECRET_KEY_BASE
ARG DATABASE_HOST
ARG DATABASE_PASSWORD

# Setting env up
ENV RAILS_ENV=$ENV
ENV RACK_ENV=$ENV
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
ENV DATABASE_HOST=$DATABASE_HOST
ENV DATABASE_PASSWORD=$DATABASE_PASSWORD

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/user-metadata-form
RUN mkdir -p $RAILS_ROOT 

# Set working directory
WORKDIR $RAILS_ROOT

# Adding project files
COPY . .
RUN bundle install --jobs 20 --retry 5 
RUN bundle exec rake assets:precompile
RUN sh ./run-migrations.sh
EXPOSE 3001

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
