bundle exec rake assets:precompile
if [ "$RACK_ENV" != "development" ]
then
  echo "Running migrations"
  bundle exec rake db:create
  bundle exec rake db:migrate
else
  echo "Not running migrations in development"
fi

echo "Starting server"
bundle exec puma -C config/puma.rb
