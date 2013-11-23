require "rvm/capistrano"
#require 'bundler/capistrano'

default_run_options[:pty] = true
set :application, "mytestapp"
 
set :scm, :git
set :repository, "git@github.com:harinisaladi/mytestapp.git"
set :scm_passphrase, ""
set :rvm_ruby_string, 'default'
set :rvm_type, :system

set :user, "ec2-user"
set :deploy_to, "/var/www/apps/mytestapp"
set :deploy_via, :remote_cache
 
set :location, "ec2-54-193-11-158.us-west-1.compute.amazonaws.com"

role :web, location
role :app, location
role :db, location, :primary => true

set :migrate_target, :latest

set :ssh_options, { :forward_agent => true }
ssh_options[:keys] = %w(~/.ec2/mytest.pem ~/.ssh/github_rsa.pub)
#after "deploy:update_code", "deploy:migrate"

namespace :deploy do
	task :start do ; end
	task :stop do ; end
	task :restart, :roles => :app, :except => { :no_release => true } do
 		run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
	end
end