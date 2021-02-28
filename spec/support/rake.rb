# frozen_string_literal: true

# Courtesy of https://www.eliotsykes.com/test-rails-rake-tasks-with-rspec
# For testing rake tasks
require 'rake'

# Task names should be used in the top-level describe, with an optional
# "rake "-prefix for better documentation. Both of these will work:
#
# 1) describe 'foo:bar' do ... end
#
# 2) describe 'rake foo:bar' do ... end
#
# Favor including 'rake '-prefix as in the 2nd example above as it produces
# doc output that makes it clear a rake task is under test and how it is
# invoked.
module TaskExampleGroup
  extend ActiveSupport::Concern

  included do
    subject(:task) { tasks[task_name] }

    let(:task_name) { self.class.top_level_description.sub(/\Arake /, '') }
    let(:tasks) { Rake::Task }

    after do
      task.all_prerequisite_tasks.each { |prerequisite| tasks[prerequisite].reenable }
      task.reenable
    end

    include(Module.new do
      def to_task_arguments(*task_args)
        Rake::TaskArguments.new(task.arg_names, task_args)
      end
    end)
  end
end

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/tasks/}) do |metadata|
    metadata[:type] = :task
  end

  config.include TaskExampleGroup, type: :task

  config.before(:suite) do
    Rails.application.load_tasks
  end
end
