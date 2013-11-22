require 'rvm-capistrano'
require 'bundler/capistrano'

default_run_options[:pty] = true

set :application, "mytestapp"
set :repository, "git@github.com:harinisaladi/mytestapp.git"
set :use_sudo, false
set :scm, :git

set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :remote_cache

set :rvm_ruby_string, "ruby-2.0.0@mytestapp"
set :rvm_type, :user
set :user, "ec2-user"
set :branch, "master"
set :location, "ec2-54-193-11-158.us-west-1.compute.amazonaws.com"

role :web, location
role :app, location
role :db, location, :primary => true

ssh_options[:forward_agent] = true 
ssh_options[:keys] = %w(~/.ec2/mytestapp.pem ~/.ssh/github_rsa.pub)

before "deploy:restart", "deploy:symlink_config"
after "deploy:symlink_config", "deploy:core"
after "deploy:symlink_config", "deploy:precompile"

namespace :deploy do
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/vendor/bundle #{release_path}/vendor/bundle"
    run "ln -nfs #{shared_path}/public/system #{release_path}/public/system"
  end

  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:clean"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
  
  task :restart, :roles => :web do
    run "cd #{current_path} && touch tmp/restart.txt"
  end

  task :core, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle install --deployment --without development test"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:create db:migrate"
  end

  task :seed, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  end
end
