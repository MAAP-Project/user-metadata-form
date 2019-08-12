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
To deploy branches, we use [capistrano](https://capistranorb.com/) .

**Note:** User Metadata Form is a monolith app. As such, deployment in this context means copying over the code from the repository to the server and restart any dependent request handlers (in our case `unicorn`). Capistrano doesn't handle aws related actions, such as creating or tearing down of instances. This has to be done via aws console.


You would either need a `pem` file or have your ssh keys added to the server to be able to deploy.

Deployment is simple. Just execute the following command from your terminal (from inside the project folder).

`bundle exec cap production deploy branch=<branch name>`

**Note:** default branch is master.

Once the deployment is done, you can find the files in the server at:
`~/pi_questionnaire/current`

It will also maintain 2 of the previous revisons.

We use [Nginx](https://www.nginx.com/) and [unicorn](https://bogomips.org/unicorn/) for serving purposes.

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
