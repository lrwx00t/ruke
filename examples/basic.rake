require_relative '../lib/ruke'
# run it:
# watch -n 1 "rake -f examples/basic.rake" --tasks -A
# watch -n 1 "rake -f examples/basic.rake" --trace
Ruke::Pipeline.new do |r|
    r.name = "hello"
    r.install_commands << "ls -alth"
    r.install_commands << "cat /etc/hosts"
    task :default => r.name
end
