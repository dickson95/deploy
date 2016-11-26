# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'deploy'
set :repo_url, 'git@github.com:dickson95/deploy.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :use_sudo, true

# Default value for :scm is :git
# set :scm, :git
set :rvm_ruby_version, '2.3.1p112@deploy'
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/puma.rb'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :puma_conf, "#{shared_path}/config/puma.rb"

namespace :deploy do
  before 'check:linked_files', 'puma:config'
  before 'check:linked_files', 'puma:nginx_config'
  after 'puma:smart_restart', 'nginx:restart'
end

namespace :nginx do
  desc 'Reload nginx'
  task :reload do
    on roles(:web), in: :sequence do
      sudo :service, :nginx, :reload
    end
  end

  desc 'Restart nginx'
  task :restart do
    on roles(:web), in: :sequence do
      execute! :sudo, :service, :nginx, :restart
    end
  end
end