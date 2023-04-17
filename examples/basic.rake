require_relative '../lib/ruke'
# run it:
# watch -n 1 "rake -f examples/basic.rake" --tasks -A
# watch -n 1 "rake -f examples/basic.rake" --trace
Ruke::Pipeline.new do |r|
    r.name = "basic_pipeline"
    r.install_commands << "echo 'ls -alth'"
    r.install_commands << "echo 'cat /etc/hosts'"
    task :default => r.name
end

# list all generated tasks
Ruke::Pipeline.new.ruke_list_all_tasks
