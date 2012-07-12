require 'spec_helper'

describe User do
  it { should respond_to(:fast_post_ids_insert) }
  it { should_not respond_to(:fast_friend_ids_insert) }
end

describe Post do
  it { should respond_to(:fast_user_ids_insert) }
end

describe Friend do
  it { should_not respond_to(:fast_user_ids_insert) }
end
