#! /usr/local/bin/ruby
require 'benchmark'

script = <<SCRIPT
  a = "blibla"
  b = ''
  300.times do |i|
    a << "bla"
  end
  a["bla"] = "foo"
SCRIPT

n = 5_000
Benchmark.bmbm do |x|

  x.report "proc:" do
    p = eval "proc { #{script} }"
    n.times { p.call }
  end
  x.report "eval:" do
    n.times { eval script }
  end
end
