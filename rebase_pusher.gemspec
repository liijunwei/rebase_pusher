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

  spec.metadata["allowed_push_host"] = spec.homepage

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]
end
