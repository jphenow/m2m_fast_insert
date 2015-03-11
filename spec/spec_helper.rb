require 'simplecov'
SimpleCov.start
RSpec.configure do |config|
  config.requires = %w[m2m_fast_insert sqlite3]

  ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each { |file| require file }

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.color = true
end
