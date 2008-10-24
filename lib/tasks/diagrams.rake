class Diagram
  def initialize
    @nodes = []
    @edges = {}
  end

  def belongs_to(child, parent)
    @edges[[parent.name, child.name]] ||= ['none', 'none']
    @edges[[parent.name, child.name]][1] = 'dot'
  end

  def has_many(parent, child)
    @edges[[parent.name, child.name]] ||= ['none', 'none']
    @edges[[parent.name, child.name]][0] = 'crow'
  end

  def has_one(parent, child)
    @edges[[parent.name, child.name]] ||= ['none', 'none']
    @edges[[parent.name, child.name]][0] = 'odot'
  end

  def model(klass)
    @nodes << klass.name
  end

  def parent(child, parent)
    @edges[[parent.name, child.name]] = ['onormal', 'none']
  end

  def to_dot
    buffer = ''
    StringIO.open(buffer) do |io|
      io.puts 'digraph models {'
      io.puts 'graph[overlap=false, splines=true]'
      @nodes.each { |node| io.puts node }
      @edges.each { |nodes, arrows| io.puts "#{nodes.first} -> #{nodes.last} [arrowtail=#{arrows.first}, arrowhead=#{arrows.last}]"}
      io.puts '}'
    end
    buffer
  end
end

desc 'Generate and open a GraphViz document representing model associations.'
task :diagrams => :environment do
  Dir.glob(Rails.root + '/app/models/**/*.rb') { |file| require file }

  diagram = Diagram.new

  model_classes = ActiveRecord::Base.send(:subclasses).reject { |klass| klass.name =~ /:/ }
  model_classes.each do |klass|
    diagram.model(klass)
    diagram.parent(klass, klass.superclass) unless klass.superclass == ActiveRecord::Base
    klass.reflect_on_all_associations.reject { |a| klass.superclass.reflect_on_all_associations.include?(a) }.each do |association|
      diagram.send(association.macro, klass, association.klass) unless association.options[:through]
    end
  end

  File.open(Rails.root + '/doc/models.dot', 'w') do |file|
    file.write(diagram.to_dot)
  end

  sh "open #{Rails.root}/doc/models.dot"
end