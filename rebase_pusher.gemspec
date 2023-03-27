# frozen_string_literal: true

require_relative "lib/rebase_pusher/version"

Gem::Specification.new do |spec|
  spec.name = "rebase_pusher"
  spec.version = RebasePusher::VERSION
  spec.authors = ["lijunwei"]
  spec.email = ["ljw532344863@sina.com"]

  spec.summary = "git rebase and push for all my branches"
  spec.description = "git rebase and push for all my branches"
  spec.homepage = "https://github.com/liijunwei/rebase_pusher"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.glob("lib/**/*.rb") + Dir.glob("bin/*")
  spec.require_paths = ["lib"]
  spec.executables = ["rebase_push"]
end
