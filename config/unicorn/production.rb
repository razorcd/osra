rails_env = "production"
app_path = "/home/deploy/osra/production"
worker_processes 1
listen "/tmp/unicorn.osra_production.sock"
working_directory "#{app_path}/current"
pid "#{app_path}/shared/tmp/pids/unicorn.pid"
stderr_path "#{app_path}/shared/log/unicorn.error.log"
stdout_path "#{app_path}/shared/log/unicorn.log"

user "deploy"

timeout 30

preload_app true

before_fork do |server, worker|
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  # puts; puts; puts; puts; puts
  # puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  # puts; puts; puts; puts; puts
  # binding.pry
  # puts

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

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/current/Gemfile"
end
