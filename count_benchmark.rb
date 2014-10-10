#! /usr/bin/env ruby

require 'benchmark'

n = 10_000_000
Benchmark.bmbm do |x|
  x.report "for" do
    for i in 1..n
      1 + 3
    end
  end
  x.report "times" do
    n.times do
      1 + 3
    end
  end

  x.report "upto" do
    1.upto(n) do
      1 + 3
    end
  end
end
