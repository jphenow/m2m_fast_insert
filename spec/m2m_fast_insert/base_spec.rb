require 'spec_helper'

module M2MFastInsert
  describe Base do
    it "has a test model" do
      test = TestModel.new
      test.should be_a TestModel
    end
  end
end
