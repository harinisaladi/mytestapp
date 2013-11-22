set :application, "mytestapp"
 
set :scm, :git
set :repository, "git@github.com:harinisaladi/mytestapp.git"
set :scm_passphrase, ""
 
set :user, "ec2-user"
set :deploy_to, "/var/www/apps/mytestapp"
 
server "ec2-54-193-11-158.us-west-1.compute.amazonaws.com", :app, :primary => true