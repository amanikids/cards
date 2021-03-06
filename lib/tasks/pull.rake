require 'shellwords'
require 'tempfile'

desc 'Back up production db locally'
task :pull do
  sh "heroku pgbackups:capture --expire --remote production"
  sh "curl -o #{Time.now.utc.to_s(:number)}.pgdump #{dburl}"
end

namespace :pull do
  def dburl
    Shellwords.escape(`heroku pgbackups:url --remote production`.strip)
  end

  desc 'Clone production db to development'
  task :development => :environment do
    sh "heroku pgbackups:capture --expire --remote production"

    Tempfile.open('dump') do |file|
      sh "curl -o #{file.path} #{dburl}"
      sh "pg_restore --verbose --clean --no-acl --no-owner -d cards_development #{file.path}"
    end

    User.find_each do |user|
      user.update_attributes(:password => 'secret')
    end
  end

  desc 'Clone production db to staging'
  task :staging do
    sh "heroku pgbackups:capture --expire --remote production"
    sh "heroku pgbackups:restore SHARED_DATABASE #{dburl} --remote staging --confirm amanikids-cards-staging"
  end
end
