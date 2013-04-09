# -*- encoding : utf-8 -*-
require "bundler/capistrano"
require "delayed/recipes"
require 'lib/recipes/db'
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "youwenti"

#set :scm, :subversion
set :scm, :mercurial
#set :local_repository,  "/home/shiningray/youwenti"
set :repository,  "https://bitbucket.org/shiningray/youwenti"
set :scm_username, 'shiningray'
set :deploy_to, defer {"/srv/#{application}"}
#set :scm_password, '123'
#set :deploy_via, :copy
#set :use_sudo, true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "www.bling0.com", :app, :web, :db, :primary => true
set :user, "root"
#role :web, "www.bling0.com"                          # Your HTTP server, Apache/etc
#role :app, "www.bling0.com"                          # This may be the same as your `Web` server
#role :db,  "www.bling0.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
#   task :start {}
#   task :stop {}
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

#  task :restart, :roles => :web, :except => {:no_release => true} do
#    pid = "/opt/nginx/logs/nginx.pid"
#    run "test -f #{pid} && #{try_sudo} kill -hup `cat #{pid}` || /opt/nginx/sbin/nginx"
#  end
  task :upload_config, :roles => :app do
    path = fetch(:config_path, "vendor/config")
    files = path.split(",").map { |f| Dir[File.join(f.strip, '*')] }.flatten
    files.each do |f|
      top.upload f, "#{shared_path}/config", :via => :scp, :recursive => true
    end
  end
end

namespace :deploy do
  task :symlink_shared, :roles => :app do
    run "#{try_sudo} ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "#{try_sudo} ln -nfs #{shared_path}/config/system_configuration.rb #{release_path}/config/system_configuration.rb"
    run "#{try_sudo} ln -nfs #{shared_path}/system #{release_path}/public/system"
    run "#{try_sudo} chmod a+w -R #{release_path}/public"
    shared_dir = File.join(shared_path,  'bundle')
    release_dir = File.join(release_path, 'vendor', 'bundle')
    run("#{try_sudo} mkdir -p #{shared_dir} && #{try_sudo} ln -s #{shared_dir} #{release_dir}")
    run "#{try_sudo} mkdir -p #{shared_path}/themes && #{try_sudo} ln -nfs #{shared_path}/themes #{release_path}/themes"
  end

  task :symlink_config, :roles => :web do
    #run "#{try_sudo} ln -nfs #{release_path}/vendor/nginx.conf /opt/nginx/conf/nginx.conf "
  end


end

after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code', 'deploy:symlink_config'
after 'deploy:setup' do
  run "#{try_sudo} chmod a+w -R #{shared_path}/log #{shared_path}/system"
  run "#{try_sudo} mkdir -p #{shared_path}/themes"
end

### control delayed_job ###
before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"

after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

after "deploy:restart", "deploy:cleanup" 
