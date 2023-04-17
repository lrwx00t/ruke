# frozen_string_literal: true

require 'rake'

# TODO
# * phases: execute, remote_execute, install, build, etc.
# * remote execution envionrment

module Ruke
  # Pipeline Class
  class Pipeline
    # include is needed to call rake task method
    include Rake::DSL

    attr_accessor :install_commands, :name

    def initialize
      @name = nil
      @install_commands = []
      yield self if block_given?
      ruke_init unless name.nil?
    end

    # all starts here
    # ---------------
    def ruke_init
      # puts '[ruke_init]: define method has been called'
      ruke_installer
    end

    def define_download
      task :installer_task do
        puts "This is default task for rake file name: [#{name}].."
        # call executor only when the task is called
        ruke_installer_executor
      end
    end

    def ruke_installer
      namespace "Ruke" do
        namespace name do
          define_download

          task :done => "Ruke:#{name}:installer_task"
          task :default => "Ruke:#{name}:done"
        end
        task name => "#{name}:default"
      end
    end

    # simple wrapper around Rake's import() method for loading .rake files
    def load_recipes(*files)
      files.flatten.each { |f| import f }
    end

    def ruke_dependson(dep)
      # count deps?? TODO
      # Ruke::Pipeline.new.load_recipes Dir["./examples/#{dep}.rake"]
      load_recipes("./examples/#{dep}.rake")
      namespace 'Ruke' do
        namespace name do
          task :default => "Ruke:#{dep}"
        end
      end
    end

    def ruke_installer_executor
      install_commands.each do |inst|
        puts "executing: [#{inst}]"
        ruke_executor(inst.to_s)
      end
    end

    def ruke_executor(cmd)
      system(cmd)
    end

    def ruke_list_all_tasks
      task_names = Rake.application.tasks.map(&:name)
      puts "Tasks:"
      task_names.each { |name| puts "  - #{name}" }
    end

    # ----------------------------------
    # 1) define the task in a code block
    # using the method is a workaround since the block is not define outside the class/module
    # wrapping the task in a method is not needed if the task bloack is defined outside the class/module
    # to run it: bundle exec bin/console
    # ----------------------------------
    def task_in_block
      # default task will be called
      # task :default do
      #   puts "default called...."
      # end

      task :inblock do
        puts 'Called task in a block..'
      end
    end

    def self.call_task_in_block
      new.task_in_block
    end
    # uncomment to execute:
    # task = self.call_task_in_block
    # Rake.application.options.trace = true
    # Rake.application.invoke_task(task)

    # ----------------------------------
    # 2) define the task inline
    # to run it: bundle exec bin/console
    # ----------------------------------
    name = 'inline_task'
    task = Rake::Task.task_defined?(name) ? Rake::Task[name] : Rake::Task.define_task(name) do
      puts 'Called inline task..'
    end
    # uncomment to execute
    # Rake.application.invoke_task(name)
    # # Rake keeps track of the executed tasks so we need to rest the task instance_variable_set
    # task.instance_variable_set(:@already_invoked, false)
    # Rake.application.invoke_task(name)
    # task.instance_variable_set(:@already_invoked, false)
    # Rake.application.invoke_task(name)
  end
end