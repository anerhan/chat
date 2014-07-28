namespace :db do
  desc "Create database config file"
  task :setup do
    on roles(:app), in: :sequence do
      template 'mongoid.yml.erb', "#{shared_path}/config/mongoid.yml"
    end
  end
end
