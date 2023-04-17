require_relative '../lib/ruke'
# run it:
# watch -n 1 "rake -f examples/dep.rake 'Ruke:dep'"


Ruke::Pipeline.new do |r|
    r.name = "dep"
    # r.ruke_dependson('basic')
    r.ruke_dependson('post_run')
end