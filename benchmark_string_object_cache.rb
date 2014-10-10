
require 'benchmark'


S = "this:is:a:line:separated:by:colon:it:contains:many:fields"
N = 2_000_000
Benchmark.bmbm do |bm|
  bm.report("without cache") do
    N.times { S.split ":" }
  end

  COLON = ":".freeze
  bm.report("with cache") do
    N.times { S.split COLON }
  end
end
