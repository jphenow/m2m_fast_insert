module M2MFastInsert
  class Base
    attr_reader :ids, :options, :id, :join_table, :join_column_name, :table_name

    def initialize(id, join_column_name, table_name, join_table, *args)
      @options = args[1].present? ? args[1] : {}
      @id = id.to_i
      @ids = args[0].collect(&:to_i)
      @ids.uniq! if options[:unique]
      raise ArgumentError, "Can't have nil ID, perhaps you didn't save the record first?" if id.nil?
      @join_table = join_table
      @join_column_name = join_column_name
      @table_name = table_name
    end

    def inserts
      @inserts ||= begin inserts = []
                     ids.each do |given_id|
                       inserts << "(#{id}, #{given_id})"
                     end
                     inserts.join ", "
                   end
    end

    def sql
      "INSERT INTO #{join_table} (`#{table_name}_id`, `#{join_column_name}_id`) VALUES #{inserts}"
    end

    def fast_insert
      ActiveRecord::Base.connection.execute(sql) unless ids.empty?
    end
  end
end
