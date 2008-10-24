load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'

def run_rake(target)
  rake = fetch(:rake, "rake")
  rails_env = fetch(:rails_env, "production")
  migrate_env = fetch(:migrate_env, "")
  migrate_target = fetch(:migrate_target, :latest)

  directory = case migrate_target.to_sym
    when :current then current_path
    when :latest  then current_release
    else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
  end

  run "cd #{directory}; #{rake} RAILS_ENV=#{rails_env} #{migrate_env} db:migrate:reset"
end

unless ENV['RAILS_ENV'] == 'production'
  namespace :deploy do
    namespace :db do
      task(:populate)  { run_rake('db:populate') }
      task(:reset)     { run_rake('db:migrate:reset') }
    end
  end

  after 'deploy', 'deploy:db:reset'
  after 'deploy', 'deploy:db:populate'
end
