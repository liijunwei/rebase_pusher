# frozen_string_literal: true

if ENV.fetch("COVERAGE", "f").start_with? "t"
  require "simplecov"

  SimpleCov.start do
    add_filter "spec/"
  end
end

require_relative "../lib/rebase_pusher"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
