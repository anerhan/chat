set :rails_env, :production
set :default_branch, 'master'

server 'chat.worldalias.com', user: 'deploy', roles: %w{web app db resque_worker}
set :deploy_to, '/var/www/apps/chat.worldalias.com'

set :nginx_server_name, 'chat.worldalias.com'
set :unicorn_workers, 4

# namespace :deploy do
#   after 'deploy:publishing', 'rollbar:notify'
# end

# set :remote_syslog_port, 25732
# set :remote_syslog_pid, 'portal_prod'
set :log_file_name, 'chat_worldalias_com_production.log'
set :log_file_name_unicorn, 'chat_worldalias_com_unicorn.log'
