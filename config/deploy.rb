set :application, 'cards_amanikids_org'
set :user,        'matthew'

if ENV['RAILS_ENV'] == 'production'
  set :database,    "#{user}_#{application}_production"
  set :domain_path, "/users/home/#{user}/domains/cards.amanikids.org"
  set :rails_env,   'production'
else
  set :database,    "#{user}_#{application}_preview"
  set :domain_path, "/users/home/#{user}/domains/cards-preview.amanikids.org"
  set :rails_env,   'staging'
end

set :deploy_to,   "#{domain_path}/var/www"

set :scm, :git
set :local_repository,  "woodward:git/#{application}.git"
set :repository,  "/users/home/#{user}/git/#{application}.git"
set :branch, 'master'
set :git_shallow_clone, 1
set :git_enable_submodules, true

set :group_writable, false
set :use_sudo, false

server 'woodward.joyent.us', :web, :app, :db, :primary => true, :user => user