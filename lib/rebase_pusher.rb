# frozen_string_literal: true

require_relative "rebase_pusher/version"

require "optparse"
require "open3"
require "json"
require "tty-spinner"

class RebasePusher
  attr_reader :options
  attr_reader :io
  attr_reader :original_branch
  attr_reader :spinner

  def initialize(options, io = $stdout)
    @options = options
    if options[:operation_type].nil?
      warn "TYPE must present"
      exit 1
    end

    @io = io
    @original_branch = sh("git rev-parse --abbrev-ref HEAD")
    @spinner = TTY::Spinner.new("[:spinner] processing...", format: :bouncing_ball)
  end

  def run
    io.puts "skipped branches: #{branches - my_branches}"
    sh("git checkout --quiet #{default_branch}")

    case options[:operation_type]
    when :rebase
      my_branches.each do |branch|
        spinner.log("reseting #{branch}")
        io.print "." if !options[:verbose]
        sh("git rebase --quiet #{default_branch} #{branch}")
        spinner.spin
      end

      io.puts if !options[:verbose]
      io.puts "all my branches are rebased"
    when :reset
      my_branches.each do |branch|
        io.print "." if !options[:verbose]
        sh("git branch --force #{branch} #{branch}@{u}")
      end

      io.puts if !options[:verbose]
      io.puts "all my branches are reset"
    when :force_push
      # https://git-scm.com/docs/git-push
      # refspec: <src>:<dst>
      my_branches.each do |branch|
        io.print "." if !options[:verbose]
        sh("git push origin --quiet --force-with-lease --force-if-includes #{branch}:#{branch}")
      end

      io.puts if !options[:verbose]
      io.puts "all my branches are force pushed"
    else
      raise "NOT SUPPORTTED"
    end
  ensure
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
