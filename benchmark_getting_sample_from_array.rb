#! /usr/bin/env ruby

require 'benchmark'

n = 5_000_000
a = [1,7,5,3,8,9,45345,123123,5756,8567,:a, :b, :khjfsd, :a, :aa, "hehe",
     :foo, :bar, "foobar", "Klass", /foo|bar/]
Benchmark.bmbm do |x|
  x.report("Array#sample") do
    n.times { a.sample }
  end
  x.report("Array#shuffle and Array#first") do
    n.times { a.shuffle.first }
  end
end
