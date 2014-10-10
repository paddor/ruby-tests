#! /usr/local/bin/ruby
require 'benchmark'

n = 50_000_000
i = 5
j = 500
Benchmark.bmbm do |x|
  x.report "i*i:" do
    n.times { i * i }
  end
  x.report "i**2:" do
    n.times { i**2 }
  end

  x.report "j*j:" do
    n.times { j * j }
  end
  x.report "i**2:" do
    n.times { j**2 }
  end

  x.report "j*j*j*j:" do
    n.times { j * j }
  end
  x.report "i**4:" do
    n.times { j**4 }
  end
end
