# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

# ref: rubocop-ast Rakefile
desc "Run RSpec with code coverage"
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].execute
  sh "open coverage/index.html"
end

task default: [:spec, :"standard:fix"]
