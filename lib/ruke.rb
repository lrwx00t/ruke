require 'rake'

# TODO:
# * phases: execute, remote_execute, install, build, etc.
# * remote execution envionrment 

module Ruke
  class Pipeline
    # include is needed to call rake task method 
    include Rake::DSL
    attr_accessor :install_commands, :name
    def initialize()
      @name = "nil"
      @install_commands = []
      yield self if block_given?
      ruke_init unless name.nil?
    end

    # all starts here
    # ---------------
    def ruke_init
      puts "[ruke_init]: define method has been called"
      ruke_installer
    end
    def ruke_installer
      desc "#{name} task"
      # default #{name} should go to the local installer_task
      task name => "#{name}:installer_task"
      namespace name do
        task :installer_task do
          puts "This is default task for rake file name: [#{name}].."
          ruke_installer_executor
        end
      end
    end
    def ruke_installer_executor
      install_commands.each do |inst|
        puts "executing: [#{inst}]"
        ruke_executor("#{inst}")
      end
    end
    def ruke_executor(cmd)
      system(cmd)
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
        puts "Called task in a block.."
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
    name = "inline_task"
    task = Rake::Task.task_defined?(name) ? Rake::Task[name] : Rake::Task.define_task(name) do
      puts "Called inline task.."
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
