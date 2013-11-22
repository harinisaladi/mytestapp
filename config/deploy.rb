require "rvm/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
set :rvm_ruby_sting, 'ruby-2.0.0@mytestapp'
set :rvm_bin_path, '/usr/local/rvm/bin'
set :application, "mytestapp"
 
set :scm, :git
set :repository, "git@github.com:harinisaladi/mytestapp.git"
set :scm_passphrase, ""
 
set :user, "ec2-user"
set :deploy_to, "/var/www/apps/mytestapp"
set :deploy_via, :remote_cache
 
set :location, "ec2-54-193-11-158.us-west-1.compute.amazonaws.com"

role :web, location
role :app, location
role :db, location, :primary => true

set :ssh_options, { :forward_agent => true }
ssh_options[:keys] = %w(~/.ec2/mytest.pem ~/.ssh/github_rsa.pub)