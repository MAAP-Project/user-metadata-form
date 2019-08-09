# set path to the application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{File.expand_path("../../..", __FILE__)}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 4
preload_app true
timeout 30

# Path for the Unicorn socket
listen "#{shared_dir}/sockets/unicorn.sock", backlog: 64

# Set path for logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set proccess id path
pid "#{shared_dir}/pids/unicorn.pid"

# # paths
# app_path = "/home/ubuntu/"
# app_name = "pi_questionnaire"
# working_directory "#{app_path}/#{app_name}/current"
# pid               "#{app_path}/current/tmp/pids/unicorn.pid"

# # listen
# listen "/tmp/unicorn-www.example.com.socket", backlog: 64

# # logging
# stderr_path "log/unicorn.stderr.log"
# stdout_path "log/unicorn.stdout.log"

# # workers
# worker_processes 3

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{File.expand_path("../..", __FILE__)}/current/Gemfile"
end

# preload
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
