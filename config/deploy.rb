# config valid only for current version of Capistrano
lock '3.4.0'

set :application, ENV.fetch('application')
set :deploy_user, ENV.fetch('deploy_user')
set :repo_url, "git@#{ENV.fetch('repo_domain')}:#{ENV.fetch('repo_owner')}/#{fetch(:application)}.git"
set :branch, ENV.fetch('repo_branch') { 'master' }
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

# RBENV
set :rbenv_path, "/home/#{fetch(:deploy_user)}/.rbenv"
set :rbenv_type, :system
set :rbenv_ruby, ENV.fetch('ruby_version') { '2.3.0' }
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

# PUMA
set :sidekiq_instances, 1
set :puma_threads, [5,5]
set :puma_workers, 2
set :puma_init_active_record, true
set :puma_preload_app, false
set :puma_conf, "#{shared_path}/config/puma.rb"

# NGINX

set :nginx_use_ssl, true
set :nginx_server_name, ENV.fetch('url')

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set(:config_files, %w(
  puma.rb
  monit.conf
  nginx.conf
  scraper.conf
  sidekiq.conf
  workers.conf
  puma.conf
))

set(:executable_config_files, %w(
  monit.conf
  nginx.conf
  scraper.conf
  sidekiq.conf
  workers.conf
  puma.conf
))

set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
  },
  {
    source: "monit.conf",
    link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf"
  },
  {
    source: "scraper.conf",
    link: "/etc/init/scraper.conf"
  },
  {
    source: "sidekiq.conf",
    link: "/etc/init/sidekiq.conf"
  },
  {
    source: "workers.conf",
    link: "/etc/init/workers.conf"
  },
  {
    source: "puma.conf",
    link: "/etc/init/puma.conf"
  }
])

namespace :deploy do

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'

  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'
  after 'deploy:setup_config', 'monit:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end
