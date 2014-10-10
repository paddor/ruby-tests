
require 'benchmark'

Benchmark.bmbm do |bm|
  bm.report("divisors.all? {...}") do
    divisors = 1.upto(20).to_a.reverse
    i = 20
    while true
      if divisors.all? {|d| i % d == 0}
        puts i
        break
      end
      i+=20
    end
  end

  bm.report("for d in divisors") do
    divisors = 1.upto(20).to_a.reverse
    i = 20
    while true
      dividable_by_all = true
      for d in divisors
        if i % d != 0
          dividable_by_all = false
          break
        end
      end
      if dividable_by_all
        puts i
        break
      end
      i+=20
    end
  end

  bm.report("while j >= 1") do
    divisors = 1.upto(20).to_a.reverse
    i = 20
    while true
      dividable_by_all = true
      j = 20
      while j >= 1
        if i % j != 0
          dividable_by_all = false
          break
        end
        j -= 1
      end
      if dividable_by_all
        puts i
        break
      end
      i+=20
    end
  end
end
