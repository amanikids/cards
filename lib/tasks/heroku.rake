require 'shellwords'

namespace :heroku do
  namespace :staging do
    namespace :db do
      def dburl
        Shellwords.escape(`heroku pgbackups:url --remote production`.strip)
      end

      desc 'Clone production db to staging'
      task :clone do
        sh "heroku pgbackups:capture --expire --remote production"
        sh "heroku pgbackups:restore #{dburl} --remote staging --confirm amanikids-cards-staging"
      end
    end
  end
end
