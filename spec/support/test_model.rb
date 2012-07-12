ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :posts_users, :id => false, :force => true do |t|
    t.references :user, :null => false
    t.references :post, :null => false
  end

  create_table :posts, :force => true do |t|
    t.string :content
  end

  create_table :connections, :force => true do |t|
    t.references :user
    t.references :friend
  end

  create_table :friends, :force => true do |t|
    t.string :type
  end
end

class User < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_many :connections
  has_many :friends, :through => :connections
end

class Post < ActiveRecord::Base
  has_and_belongs_to_many :users
end

class Connection < ActiveRecord::Base
  has_many :friends
  has_many :users
end

class Friend < ActiveRecord::Base
  has_many :connections
  has_many :users, :through => :connections
end
