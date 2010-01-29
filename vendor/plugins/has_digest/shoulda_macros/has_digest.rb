module HasDigest
  module Shoulda
    # Asserts that <tt>has_digest :name</tt> has been called with the given
    # options, and that the necessary database columns are present. +options+
    # may contain two keys:
    # * +depends+: either a single attribute name or an array of attribtues
    #   names. (Specifying <tt>:salt</tt> here is unnecessary.)
    # * +limit+: if your db column for the given digest doesn't have
    #   <tt>:limit => 40</tt>, you may specify its size here.
    def should_have_digest(name, options = {})
      options.assert_valid_keys(:depends, :limit)

      context "#{described_type.name} with has_digest :#{name}" do
        should_have_db_column name, :type => :string, :limit => (options[:limit] || 40)

        should "generate digest for :#{name}" do
          assert_not_nil self.class.described_type.has_digest_attributes[name]
        end

        if options[:depends]
          dependencies = options[:depends]
          dependencies = [dependencies] unless dependencies.respond_to?(:each)
          dependencies.unshift(:salt) if described_type.column_names.include?('salt')

          should "generate digest for :#{name} from #{dependencies.to_sentence}" do
            attributes = self.class.described_type.has_digest_attributes[name] || {}
            assert_equal dependencies, attributes[:dependencies]
          end
        end
      end
    end
  end
end

Test::Unit::TestCase.extend(HasDigest::Shoulda)
