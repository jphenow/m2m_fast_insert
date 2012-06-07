module M2MFastInsert
  module HasAndBelongsToManyOverride
    def self.included(klass)
      klass.class_eval do
        # Create Method chain if habtm is defined - This is because it goes down to AR::Base
        # and errors because at the time of inclusion, there is none defined
        alias_method_chain :has_and_belongs_to_many, :fast_inserts if self.method_defined? :has_and_belongs_to_many
      end
    end

    # Rig the original habtm to call our method definition
    #
    # name - Plural name of the model we're associating with
    # options - see ActiveRecord docs
    def has_and_belongs_to_many_with_fast_inserts(name, options = {})
      has_and_belongs_to_many_without_fast_inserts(name, options)
      define_fast_methods_for_model(name, options)
    end

    private
    # Get necessary table and column information so we can define
    # fast insertion methods
    #
    # name - Plural name of the model we're associating with
    # options - see ActiveRecord docs
    def define_fast_methods_for_model(name, options)
      join_table = options[:join_table]
      join_column_name = name.to_s.downcase.singularize
      define_method "fast_#{join_column_name}_ids_insert" do |ids, options|
        raise TypeError, "IDs must be fixnums" if ids.any? { |i| !i.is_a? Fixnum }
        options ||= {} # Don't think we can use defaults for define_method
        ids.uniq if options[:unique]
        table_name = self.class.table_name.singularize
        inserts = []
        ids.each do |given_id|
          inserts << "(#{id}, #{given_id})"
        end
        sql = "INSERT INTO #{join_table} (`#{table_name}_id`, `#{join_column_name}_id`) VALUES #{inserts.join(", ")}"
        ActiveRecord::Base.connection.execute sql
      end
    end
  end
end
ActiveRecord::AutosaveAssociation::ClassMethods.send :include, M2MFastInsert::HasAndBelongsToManyOverride
