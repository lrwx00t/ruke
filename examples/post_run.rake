require_relative '../lib/ruke'
# run it:
# watch -n 1 "rake -f examples/basic.rake" --tasks -A
# watch -n 1 "rake -f examples/basic.rake" --trace
Ruke::Pipeline.new do |r|
    r.name = "post_run"
    r.install_commands << "echo '********* All Completed!'"
end