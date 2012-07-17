require 'spec_helper'

module M2MFastInsert
  describe Base do
    let(:id) { 1 }
    let(:join_column_name) { 'post' }
    let(:table_name) { 'user' }
    let(:join_table) { 'posts_users' }
    describe "basic init" do
      let(:ids) { [1,2,3] }
      subject do
        Base.new(id, join_column_name, table_name, join_table, ids)
      end

      it { should respond_to :fast_insert }

      it "allows a basic init" do
        subject.id.should == id
        subject.join_column_name.should == join_column_name
        subject.table_name.should == table_name
        subject.join_table.should == join_table
        subject.ids.should == ids
        subject.options.should == {}
      end

      it "builds inserts" do
        subject.inserts.should == "(1, 1), (1, 2), (1, 3)"
      end

      it "builds INSERT statement" do
        subject.sql.should == "INSERT INTO posts_users (`user_id`, `post_id`) VALUES #{subject.inserts}"
      end

      it "executes SQL" do
        ActiveRecord::Base.connection.should_receive(:execute).with(subject.sql)
        subject.fast_insert
      end
    end

    describe "basic init" do
      let(:ids) { [1,2,Base] }
      it "denies non-fixnum ids" do
        expect {
          Base.new(id, join_column_name, table_name, join_table, ids)
        }.to raise_error(NoMethodError)
      end
    end
  end
end
