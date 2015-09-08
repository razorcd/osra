rails_env = "production"
# app_path = "/home/rails/ig_#{rails_env}"
app_path = "/home/deploy/osra/production"
worker_processes 8
listen "/tmp/unicorn.ig_#{rails_env}.sock"
working_directory "current"
pid "#{app_path}/shared/pids/unicorn.pid"
stderr_path "#{app_path}/shared/log/unicorn.error.log"
stdout_path "#{app_path}/shared/log/unicorn.log"

user "deploy"

timeout 30

preload_app true

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
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
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/current/Gemfile"
end
