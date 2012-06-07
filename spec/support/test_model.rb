class TestModel < ActiveRecord::Base
  has_and_belongs_to_many :other_models
end
