FROM ruby:2.5.1

ARG SECRET_KEY_BASE

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/user-metadata-form
RUN mkdir -p $RAILS_ROOT 

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='development'
ENV RACK_ENV='development' 
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 20 --retry 5 

# Adding project files
COPY . .
RUN bundle exec rake assets:precompile
EXPOSE 3001

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
