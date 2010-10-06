namespace :graphite do

  desc 'Display a graph of model relationships.'
  task :models => :environment do
    Rails.root.join('app', 'models').find do |path|
      require path if path.extname == '.rb'
    end

    Graphite::Graph.open(:rankdir => 'BT') do |graph|
      ActiveRecord::Base.send(:subclasses).each do |klass|
        klass.reflect_on_all_associations(:belongs_to).each do |association|
          graph.edge(klass.name, association.class_name, association.name.to_s.classify)
        end
      end
    end
  end

end
