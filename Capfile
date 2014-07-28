require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano3/nginx_unicorn'
require 'capistrano-resque'

Dir.glob('lib/capistrano/tasks/*.rb').each { |r| import r }
