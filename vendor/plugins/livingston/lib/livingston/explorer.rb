module Livingston
  class Explorer
    attr_reader :diagram
    
    def initialize(diagram = Diagram.new)
      @diagram = diagram
    end
    
    # TODO don't take a list of files, just take a directory (defaulting to app/models)
    # TODO rather than requiring each file, just classify and constantize the basename, then use the resulting class.
    def explore(files)
      files.each { |file| require file }
      
      subclasses_of(ActiveRecord::Base).reject { |klass| klass == CGI::Session::ActiveRecordStore::Session }.each do |model_class|
        @diagram.model(model_class)
        @diagram.parent(model_class, model_class.superclass) unless model_class.superclass == ActiveRecord::Base

        model_class.reflect_on_all_associations.reject { |a| model_class.superclass.reflect_on_all_associations.include?(a) }.each do |association|
          @diagram.send(association.macro, model_class, association.klass) unless association.options[:through]
        end
      end
    end
  end
end