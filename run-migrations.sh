if [ "$RACK_ENV" == "production" ]
then
  echo "Running migrations in production"
  bundle exec rake db:create
  bundle exec rake db:migrate
else
  echo "Not running migrations in development"
fi

