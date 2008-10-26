# TODO would it help to make Node and Edge classes?
module Livingston
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
end
