# config valid only for current version of Capistrano
# lock '3.4.0'

# app_path = "/home/deploy/osra/production"
# working_directory "#{app_path}/current"
# pid "#{app_path}/current/tmp/pids/unicorn.pid"

# set :stage, :production
# set :rails_env, "production"
set :application, 'OSRA-razorcd'
set :repo_url, 'git@github.com:razorcd/osra.git'

# set :user, "deploy"
# set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_binstubs, nil




# APP_PATH = "/home/deploy/osra/production"
# working_directory "#{APP_PATH}/current"

# stderr_path APP_PATH + "/log/unicorn.stderr.log"
# stdout_path APP_PATH + "/log/unicorn.stderr.log"

# pid "#{APP_PATH}/shared/tmp/pids/unicorn.pid"




# set :unicorn_config_path, "#{app_path}/current/config/deploy/production.rb"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/home/deploy/osra'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  # desc 'Restart Unicorn'
  # task :restart do
  #   invoke 'unicorn:restart'
  # end

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Exec on server'
  task :exec do
    on roles(:web) do
      execute "rvm gemdir"
    end
  end


  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
