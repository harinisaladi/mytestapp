require 'bundler/capistrano'
default_run_options[:pty] = true

set :user, "ec2-user"
set :use_sudo, false
set :repository, "git@github.com:harinisaladi/mytestapp.git"
set :branch, "master"
set :application, "mytestapp"
set :deploy_to, "/var/www/apps/#{application}"
set :location, "ec2-54-193-11-158.us-west-1.compute.amazonaws.com"

role :web, location
role :app, location
role :db, location, :primary => true

ssh_options[:forward_agent] = true 
ssh_options[:keys] = %w(~/.ec2/mytestapp.pem ~/.ssh/github_rsa.pub)