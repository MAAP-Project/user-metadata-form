# User Metadata Form

This form serves a similar purpose to the original PI Questionnaire, but is focused on the user shared metadata workflow. Before a collection gets ingested into the Pilot MAAP, the data provider is required to fill out this for. This form will be used to populate metadata fields for the data set.

This repo is a fork of /pi-questionnaire and the following Readme has not been changed.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to [deploy](#deployment) the project on a live system.

1. Clone this repo `git clone git@github.com:NASA-IMPACT/user-metadata-form.git`
2. `cd user-metadata-form`

### Prerequisites

Before moving into installing all the gems used, please make sure that you have ruby installed. You can do so by typing `ruby -v` in your terminal. We are currently using `ruby 2.5.1` as described in the `.ruby-version` file. If your machine doesn't have any ruby binaries, you can follow [this blog](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_language_runtime.html) .

After ruby is installed, install `bundler` using `gem install bundler` in your terminal. Bundler is a package (gem) manager for ruby. You can read about it at [Bundlers' website](https://bundler.io/) .

We use postgres as our database. If your machine doesn't have postgres installed, please do so. You can follow [Postgres installation guide](https://wiki.postgresql.org/wiki/Detailed_installation_guides) .

### Installing

Once ruby and postgres is properly installed, change directory into the project folder if you have not already. `cd pi_questionnaire`.

Then we need to install the gems used in the project, prepare the database etc.

1. `bundle install`
2. `bundle exec rails db:create`
3. `bundle exec rails db:migrate`

**Note:** For all of this, following assumptions are made:

1. The postgres user has create, and modify previleges.
2. Postgres is running in the background.

Once all of the migration is complete, you can check if this is working or not by starting the server. You can do so by using `rails s`. This will start the server in port 3000. Go to your browser, navigate to `localhost:3000`. You should be able to see the following page.

![screenshot_home.jpg](./images/screenshot_home.png)

## Deployment

Deployment uses `docker-compose` to run an app (rails), web (nginx) and db (postgres) services. See required files in the [`docker/`](./docker) directory of this repo.

You can build the services locally or on a remote server with the following commands:

```bash
docker-compose build --build-arg SECRET_KEY_BASE=<ADD ME>
docker-compose run app rake db:create RAILS_ENV=production
docker-compose run app rake db:migrate db:seed RAILS_ENV=production
docker-compose up -d
```

To run the service on AWS EC2:

1. Launch an ECS-Optimized Amazon Linux 2 AMI (most recently used `ami-0fac5486e4cff37f4`)
2. Install `git` and `docker-compose`:

```bash
sudo yum install git -y
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

The follow command is useful in order to update just the app service:

```bash
docker-compose build --build-arg SECRET_KEY_BASE=<ADD_ME> app
docker-compose up --no-deps -d app
```

Additionally, to configure the https://questionnaire.maap-project.org DNS:

1. Create a target group pointing to the private IP of the EC2 at port 80, say it's called `questionnaire-targets`.
2. Find or create an ELB. The ELB configuration makes it easy to add and use the SSL certificate for the subdomain questionnaire.maap-project.org. Create 2 listeners for the ELB:
    1. HTTP:80 Redirecting to `HTTPS://#{host}:443/#{path}?#{query}`
    2. HTTPS:443 Forwarding to your target group, e.g. `questionnaire-targets`.

### Deployment TODOs

* Include instruction on generating `.env` file
* Automate process of building

## Built With

* [Rails](https://rubyonrails.org/) - The web framework used
* [Bundler](https://bundler.io/) - Dependency Management

## Contributing

To make your changes:

1. Fork this repo.
2. If you are working on a feature, use the naming convention `feature-<feature name>`, if it's a bug use `bug-<name>`. (please make sure there is a corresponding issue listed at https://github.com/nasa-impact/pi_questionnaire/issues before working on the changes.)
3. Create a pull request against the master branch of this repo.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
