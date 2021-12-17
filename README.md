# User Metadata Form

This form serves a similar purpose to the original PI Questionnaire, but is focused on the user shared metadata workflow. Before a collection gets ingested into the Pilot MAAP, the data provider is required to fill out this for. This form will be used to populate metadata fields for the data set.

This repo is a fork of /pi-questionnaire and the following Readme has not been changed.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to [deploy](#deployment) the project on a live system.

1. Clone this repo `git clone git@github.com:MAAP-Project/user-metadata-form.git`
2. `cd user-metadata-form`

### Prerequisites

Before moving into installing all the gems used, please make sure that you have ruby installed. You can do so by typing `ruby -v` in your terminal. We are currently using `ruby 2.7.5` as described in the `.ruby-version` file. If your machine doesn't have any ruby binaries, you can follow [this blog](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_language_runtime.html) .

After ruby is installed, install `bundler` using `gem install bundler` in your terminal. Bundler is a package (gem) manager for ruby. You can read about it at [Bundlers' website](https://bundler.io/) .

We use postgres as our database. If your machine doesn't have postgres installed, please do so. You can follow [Postgres installation guide](https://wiki.postgresql.org/wiki/Detailed_installation_guides) .

### Installing

Once ruby and postgres is properly installed, change directory into the project folder if you have not already. `cd user-metadata-form`.

Then we need to install the gems used in the project, prepare the database etc.

1. `bundle install`
2. `bundle exec rails db:create`
3. `bundle exec rails db:migrate`

**Note:** For all of this, following assumptions are made:

1. The postgres user has create, and modify privileges.
2. Postgres is running in the background.

Once all of the migration is complete, you can check if this is working or not by starting the server. You can do so by using `rails s`. This will start the server in port 2998. Go to your browser, navigate to `localhost:2998`. You should be able to see the following page.

![screenshot_home.jpg](./images/screenshot_home.png)

## Deployment

See [deployment/README.md](./deployment/README.md).

## Built With

* [Rails](https://rubyonrails.org/) - The web framework used
* [Bundler](https://bundler.io/) - Dependency Management

## Contributing

To make your changes:

1. Fork this repo.
2. If you are working on a feature, use the naming convention `feature-<feature name>`, if it's a bug use `bug-<name>`. (please make sure there is a corresponding issue listed at https://github.com/MAAP-Project/user-metadata-form/issues before working on the changes.)
3. Create a pull request against the master branch of this repo.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
