FROM ruby:2.7.5

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
      apt-get install -y build-essential libpq-dev nodejs postgresql-client && \
      apt-get clean

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/user-metadata-form
RUN mkdir -p $RAILS_ROOT 

# Set working directory
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem update bundler
RUN bundle install --jobs 20 --retry 5 

# Adding project files
COPY . .
RUN bundle
EXPOSE 2998

CMD [ "bash", "./migrate-and-serve.sh" ]
