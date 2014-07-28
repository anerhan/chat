namespace :db do
  desc "Create database config file"
  task :setup do
    on roles(:app), in: :sequence do
      template 'faye.yml.erb', "#{shared_path}/config/faye.yml"
    end
  end
end
