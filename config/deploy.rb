
require "bundler/capistrano" 

set :application, "mytestapp"
set :repository, "git@github.com:harinisaladi/mytestapp.git"
set :scm, :git

set :user, "ec2-user"
set :use_sudo, false

set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :remote_cache

set :branch, "master"
set :location, "ec2-54-193-11-158.us-west-1.compute.amazonaws.com"

role :web, location
role :app, location
role :db, location, :primary => true

ssh_options[:forward_agent] = true 
ssh_options[:keys] = %w(~/.ec2/mytestapp.pem ~/.ssh/github_rsa.pub)


namespace :deploy do
	task :start do ; end
    task :stop do ; end
    task :restart, :roles => :app, :except => { :no_release => true } do     
    	run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    end
end

set :keep_releases, 5
after 'deploy:update_code', 'deploy:migrate'
after "deploy:restart", "deploy:cleanup" 
