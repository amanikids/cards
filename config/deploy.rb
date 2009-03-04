set :application, 'cards'
set :repository,  "git://github.com/amanikids/#{application}.git"

set :deploy_to, "/var/www/apps/#{application}"
set :user, 'deploy'
set :use_sudo, false

set :scm, :git
set :local_repository, '.git'
set :branch, 'master'
set :git_shallow_clone, 1
set :git_enable_submodules, true

server 'amanikids.joyeurs.com', :web, :app, :db, :primary => true, :user => user


def create_symlink(path)
  run "rm -rf #{latest_release}/#{path}; ln -s #{shared_path}/#{path} #{latest_release}/#{path}"
end

namespace :deploy do
  desc 'Restart the Application'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  namespace :shared do
    desc 'Symlink shared content and configuration'
    task :symlinks do
      create_symlink 'config/database.yml'
      create_symlink 'config/secret.txt'
    end
  end
end

after 'deploy:finalize_update', 'deploy:shared:symlinks'
