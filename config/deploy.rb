lock '3.1.0'

set :application, 'chat'

set :pty, true
set :ssh_options, { forward_agent: true }
set :user, 'deploy'

# rvm
set :rvm_type, :user
set :rvm_ruby_version, '2.1.2'

# scm
set :scm, :git
set :repo_url, 'git@git.worldalias.com:chat.git'
set :branch, -> { "#{ENV['branch'] || fetch(:default_branch)}" }
set :keep_releases, 2

# symlinks
set :linked_files, %w{config/mongoid.yml config/faye.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Database setup
set :db_adapter, "mongodb"
set :db_name, "chat_production"
set :db_hosts, %w|localhost:27017|
set :db_options, { raise_not_found_error: false }

#Nginx
set :nginx_port, 80

#Faye
set :faye_mount, 'faye/chat'
set :faye_port, 9295
set :faye_timeout, 45
set :faye_host, 'chat.worldalias.com'
set :faye_secret, 'slkjsafhkjfaskjh7asf9f8as7fas8f0'


#Unicorn
set :unicorn_user, 'deploy'
set :unicorn_workers, 2
set :unicorn_pid, -> { "#{current_path}/tmp/pids/unicorn.pid" }

# Resque
set :workers, { 'websockets' => 1 }

namespace :deploy do
  before :migrate, 'config:make'
  # before :migrate, 'db:create'
  # after :migrate, 'db:init'
  after :publishing, 'resque:restart'
end

