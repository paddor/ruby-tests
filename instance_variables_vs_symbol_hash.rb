require 'benchmark'

N = 2_000_000

class HashRecord
  def initialize()
    @v = {}
  end
  def aaaaaaaaaaa=(o) @v[:aaaaaaaaaaa] = o end
  def bbbbbbbbbbb=(o) @v[:bbbbbbbbbbb] = o end
  def ccccccccccc=(o) @v[:ccccccccccc] = o end
  def ddddddddddd=(o) @v[:ddddddddddd] = o end
  def eeeeeeeeeee=(o) @v[:eeeeeeeeeee] = o end
  def fffffffffff=(o) @v[:fffffffffff] = o end
  def ggggggggggg=(o) @v[:ggggggggggg] = o end
  def values()
    [ @v[:aaaaaaaaaaa],
      @v[:bbbbbbbbbbb],
      @v[:ccccccccccc],
      @v[:ddddddddddd],
      @v[:eeeeeeeeeee],
      @v[:fffffffffff],
      @v[:ggggggggggg]
    ]
  end
end

class IvarRecord
  def aaaaaaaaaaa=(o) @aaaaaaaaaaa = o end
  def bbbbbbbbbbb=(o) @bbbbbbbbbbb = o end
  def ccccccccccc=(o) @ccccccccccc = o end
  def ddddddddddd=(o) @ddddddddddd = o end
  def eeeeeeeeeee=(o) @eeeeeeeeeee = o end
  def fffffffffff=(o) @fffffffffff = o end
  def ggggggggggg=(o) @ggggggggggg = o end
  def values()
    [ @aaaaaaaaaaa,
      @bbbbbbbbbbb,
      @ccccccccccc,
      @ddddddddddd,
      @eeeeeeeeeee,
      @fffffffffff,
      @ggggggggggg
    ]
  end
end

IVAR_RECORDS = []
HASH_RECORDS = []

S = "something something"

puts "CREATION:"
Benchmark.bmbm do |bm|
  bm.report "HashRecord" do
    HASH_RECORDS.clear
    N.times do |i|
      r = HashRecord.new
      r.aaaaaaaaaaa = S
      r.bbbbbbbbbbb = S
      r.ccccccccccc = S
      r.ddddddddddd = S
      r.eeeeeeeeeee = S
      r.fffffffffff = S
      r.ggggggggggg = S
      HASH_RECORDS << r
    end
  end

  bm.report "IvarRecord" do
    IVAR_RECORDS.clear
    N.times do |i|
      r = IvarRecord.new
      r.aaaaaaaaaaa = S
      r.bbbbbbbbbbb = S
      r.ccccccccccc = S
      r.ddddddddddd = S
      r.eeeeeeeeeee = S
      r.fffffffffff = S
      r.ggggggggggg = S
      IVAR_RECORDS << r
    end
  end
end

puts "\n\nFIELDS:"
Benchmark.bmbm do |bm|
  bm.report "HashRecord" do
    HASH_RECORDS.each { |r| r.values }
  end

  bm.report "IvarRecord" do
    IVAR_RECORDS.each { |r| r.values }
  end
end
