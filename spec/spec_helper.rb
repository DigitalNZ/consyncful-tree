# frozen_string_literal: true

require "consyncful/tree"
require "bundler/setup"
require "consyncful"
require "database_cleaner-mongoid"
require "pry-byebug"

Mongoid.load!("spec/support/mongoid.yml", :test)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
