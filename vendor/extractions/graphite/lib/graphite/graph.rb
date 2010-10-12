module Graphite
  require 'tempfile'

  class Graph
    def self.open(*args)
      graph = new(*args)
      yield graph
      graph.open
    end

    def initialize(*args)
      @options = args.extract_options!
      @format  = args.first || 'png'
      @edges   = []
    end

    def edge(from, to)
      @edges.push([from, to])
    end

    def open
      Tempfile.open(['graph', ".#{@format}"]) do |graph|
        graph.write(image)
        graph.flush
        system 'open', '-W', graph.path
      end
    end

    private

    def image
      IO.popen("dot -T#{@format}", 'r+') do |pipe|
        pipe.write(dot)
        pipe.close_write
        pipe.read
      end
    end

    def dot
      StringIO.open do |dot|
        dot.puts 'digraph {'

        @options.sort.each do |key, value|
          dot.puts "  #{key}=#{value};"
        end

        @edges.sort.each do |from, to|
          dot.puts "  #{from} -> #{to};"
        end

        dot.puts "}"
        dot.string
      end
    end
  end
end
