# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :branch, ENV['branch'] if ENV['branch']
set :application, "pi_questionnaire"
set :repo_url, " git@github.com:NASA-IMPACT/pi_questionnaire.git"
set :user, 'ubuntu'
set :rails_env, 'production'
set :log_level, :info # default: :debug
set :use_sudo, false
# set :migration_role, 'app';
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

Rake::Task["deploy:check:linked_dirs"].clear_actions
# set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/templates public/assets} # default: []

# Default value for :scm is :git
# set :scm, :git

# set :pty, true
set :ssh_options, {
  forward_agent: true,
  paranoid: true,
  auth_methods: ['publickey'],
  keys: ['~/.ssh/id_rsa.pub', '~/projects/.pemfiles/maap-pi-form.pem']
}

set :keep_releases, 2 # default is 5

set :unicorn_pid, "#{shared_path}/pids/unicorn*.pid"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
set :unicorn_options, { port: 3000, unicorn_rack_env: "production" }

namespace :deploy do
  task :restart do
    invoke 'deploy:compile_assets'
    invoke 'unicorn:restart'
  end
end

# namespace :deploy do
#   desc 'Restart application'
#   task :source do
#     on roles(:app), in: :sequence, wait: 5 do
#       within "#{current_path}" do
#         with rails_env: :production do
#           execute("source /home/ubuntu/.credentials")
#           # file_name = 'shared/pids/unicorn.pid'
#           # if File.exists?('shared/pids/unicorn.pid')
#           #   pid = File.read('shared/pids/unicorn.pid').delete('\n')
#           #   system('kill', pid)
#           # end
#           # invoke 'unicorn:start'
#         end
#       end
#     end
#   end
#   after :publishing, :restart
# end

namespace :debug do
  desc 'Print ENV variables'
  task :env do
    on roles(:app), in: :sequence, wait: 5 do
      execute :printenv
    end
  end
end

after 'deploy:publishing', 'debug:env'
after 'deploy:publishing', 'deploy:restart'
# after 'deploy:source', 'deploy:restart'
# # for sidekiq using capistrano-sidekiq
# set :sidekiq_role, :worker
# set :sidekiq_processes, 2
# set :sidekiq_use_signals, true
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

# set :rvm1_map_bins, fetch(:rvm1_map_bins).to_a.concat(%w(sidekiq sidekiqctl))


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false


# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
