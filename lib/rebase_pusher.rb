# frozen_string_literal: true

require_relative "rebase_pusher/version"

require "optparse"
require "open3"
require "json"

class RebasePusher
  attr_reader :options
  attr_reader :io
  attr_reader :original_branch

  def initialize(options, io = $stdout)
    @options = options
    @io = io
    @original_branch = sh("git rev-parse --abbrev-ref HEAD")
  end

  def run
    branches_to_operate = my_branches - not_synced_branches
    io.puts "branches_to_operate: #{branches_to_operate}"

    case options[:operation_type]
    when :rebase
      io.puts "rebase all my branches"

      branches_to_operate.each do |branch|
        sh("git rebase --quiet #{default_branch} #{branch}")
      end
    when :reset
      io.puts "reset all my branches"

      branches_to_operate.each do |branch|
        sh("git checkout --quiet #{branch}")
        sh("git reset    --quiet --hard HEAD@{u}")
      end
    when :force_push
      io.puts "force push all my branches"

      # https://git-scm.com/docs/git-push
      # refspec: <src>:<dst>
      branches_to_operate.each do |branch|
        sh("git push origin --quiet --force-with-lease --force-if-includes #{branch}:#{branch}")
      end
    when :check
      io.puts "not synced branches: #{not_synced_branches}"
    else
      raise "NOT SUPPORTTED"
    end

    io.puts
    sh("git checkout --quiet #{original_branch}")
  end

  private

  # Ensure I never touch other people's branch
  def my_branches
    @my_branches ||= branches.select do |branch|
      merge_base_commitid = sh("git merge-base #{default_branch} #{branch}").chomp
      author_emails = sh("git log --format='%ae' #{merge_base_commitid}..#{branch}").split("\n").uniq

      !author_emails.empty? && author_emails.all? { |email| email == my_email }
    end
  end

  def default_branch
    @default_branch ||= sh("git rev-parse --abbrev-ref origin/HEAD").chomp
  end

  def branches
    @branches ||= sh('git branch | grep "[^* ]+" -Eo').split("\n")
  end

  def not_synced_branches
    @not_synced_branches ||= my_branches.select do |branch|
      sh("git rev-list --count #{branch}..origin/#{branch}").to_i != 0
    end
  end

  def my_email
    @my_email ||= sh("git config --get user.email").chomp
  end

  def sh(cmd)
    if options[:verbose]
      io.puts "running command: #{cmd}"
    end

    out, err, status = Open3.capture3(*cmd)

    if status.success?
      out
    else
      info = {
        output: out,
        error: err,
        status: status,
        backtraces: caller
      }

      warn info.to_json
      raise "command failed: #{cmd}"
    end
  end
end
