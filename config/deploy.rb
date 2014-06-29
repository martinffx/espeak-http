require "capistrano-rbenv"
require 'capistrano/puma'

# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'talktome'
set :repo_url, 'git@github.com:martinffx/talktome.git'
set :user, 'deployer'

set :branch, 'master'
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :scm, :git

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets}

set :format, :pretty
set :log_level, :info
set :pty, true

set :keep_releases, 5

# nginx
set :nginx_config, "config/deploy/shared/nginx.conf.erb"
set :server_name, "talktome"

# Rbenv
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle}
set :rbenv_roles, :all # default value

# Puma
set :puma_rackup, "./config.ru"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix:/tmp/puma.#{fetch(:application)}.sock"
set :puma_upstream, "puma-#{fetch(:application)}"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_init_active_record, false

namespace :deploy do
  task :create_tmp do
    on roles(:all) do
      execute :touch, "#{fetch(:puma_access_log)}"
      execute :touch, "#{fetch(:puma_error_log)}"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :starting, :create_tmp
  after :finishing, 'deploy:cleanup', 'nginx:restart'

end
