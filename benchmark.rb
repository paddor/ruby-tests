#! /usr/local/bin/ruby
require 'benchmark'

# Various benchmarks.

#class Foo
#  @var = "hehe"
#  def self.var() @var end
#  def var() self.class.var end
#end
#
#class Bar
#  @@var = "hehe"
#  def var() @@var end
#end
#
#class Baz
#  @var = "hehe"
#  def self.var() @var end
#  def var() Baz.var end
#end
#
#
#n = 5_000_000
#puts "\n\n########### lookup of class variable ###########"
#Benchmark.bmbm do |bm|
#  foo = Foo.new
#  bm.report("self.class.var") { n.times { foo.var } }
#
#  bar = Bar.new
#  bm.report("@@var") { n.times { bar.var } }
#
#  baz = Baz.new
#  bm.report("Class.var") { n.times { baz.var } }
#end
#
#print "\n\n"


#class String
#  SecondsHash = Hash.new do |h,k|
#    if k =~ /(?:(\d+)h)?(?:(\d+)m)?/
#      seconds = (($1 || 0).to_i * 3600) + (($2 || 0).to_i * 60)
#    end
#    h[k] = seconds
#  end
#
#  def to_seconds
#    return unless self =~ /(?:(\d+)h)?(?:(\d+)m)?/
#    (($1 || 0).to_i * 3600) + (($2 || 0).to_i * 60)
#  end
#
#  def to_seconds2
#    hours, minutes = split("h") #.map(&:to_i) #{ |s| s.to_i }
#    if hours and minutes
#      hours.to_i * 3600 + minutes.to_i * 60
#    else
#      if self =~ /(?:(\d+)h)?(?:(\d+)m)?/
#        (($1 || 0).to_i * 3600) + (($2 || 0).to_i * 60)
#      end
#    end
#  end
#
#  def to_seconds3
#    return (8 * 3600 + 30 * 60) if self == "8h30m"
#    to_seconds
#  end
#
#  def to_seconds3_2
#    8 * 3600 + 30 * 60
#  end
#
#  def to_seconds4
#    SecondsHash[self]
#  end
#end
#
#SecondsHash2 = Hash.new do |h,k|
#  if k =~ /(?:(\d+)h)?(?:(\d+)m)?/
#    seconds = (($1 || 0).to_i * 3600) + (($2 || 0).to_i * 60)
#  end
#  h[k] = seconds
#end
#
#SecondsHashWithSplit = Hash.new do |h,k|
#  hours, minutes = k.split("h") #.map(&:to_i) #{ |s| s.to_i }
#  h[k] = #if hours and minutes
#    hours.to_i * 3600 + minutes.to_i * 60
#  #else
#    #k =~ /(?:(\d+)h)?(?:(\d+)m)?/
#    #(($1 || 0).to_i * 3600) + (($2 || 0).to_i * 60)
#  #end
#end
#
#n = 1_500_000
#puts "\n\n########## transform '8h30m' to number of seconds ##########"
#Benchmark.bmbm do |bm|
##  bm.report("String#to_seconds with regex") { n.times { "8h30m".to_seconds } }
##  bm.report("String#to_seconds with split") { n.times { "8h30m".to_seconds2 } }
##  bm.report("8 * 3600 + 30 * 60") { n.times { "8h30m".to_seconds3 } }
##  bm.report("8 * 3600 + 30 * 60 without if") { n.times { "8h30m".to_seconds3_2 } }
#  bm.report("String#to_seconds with Hash") { n.times { "8h30m".to_seconds4 } }
#  bm.report("bare Hash") { n.times { SecondsHash2["8h30m"] } }
#  bm.report("bare Hash with split") { n.times { SecondsHashWithSplit["8h30m"] } }
#end

#n = 25_000_000
#puts "\n\n########## count to #{n}  ##########"
#Benchmark.bmbm do |bm|
#  bm.report("while true") { a=0; while true; a+=1; break if a > n end  }
#  bm.report("loop { }") { a=0; loop { a+=1; break if a > n } }
#  bm.report("while a<=n") { a=0; a+=1 while a <= n }
#  bm.report("until a>n") { a=0; a+=1 until a > n }
#  bm.report("n.times ") { a=0; n.times{a+=1} }
#  bm.report("(0..n).each") { a=0; (0..n).each { |i|a=i} }
#  bm.report("for a in 0..n") { a=0; for a in 0..n; end}
#end

#n = 500_000
#puts "\n\n########## rescue  ##########"
#Benchmark.bmbm do |bm|
#  bm.report("begin rescue end") do
#    a=0
#    while true
#      a+=1
#      begin
#        raise "figg"
#      rescue
#        nil
#      end
#      break if a > n
#    end
#  end
#
#  bm.report("rescue nil") do
#    a=0
#    while true
#      a+=1
#      raise "figg" rescue nil
#      break if a > n
#    end
#  end
#
#  bm.report("no exception at all") do
#    a=0
#    while true
#      a+=1
#      break if a > n
#    end
#  end
#end

#n = 15_000_000
#puts "\n\n########## (rare) exception handling in loop  ##########"
#Benchmark.bmbm do |bm|
#  bm.report("while begin rescue end end") do
#    i = 0
#    while true
#      begin
#        i += 1
#        break if i > n
#        raise "figg" if i % 100_000 == 0
#      rescue
#        next
#      end
#    end
#  end
#
#  bm.report("begin while end rescue end") do
#    i = 0
#    begin
#      while true
#        i += 1
#        break if i > n
#        raise "figg" if i % 100_000 == 0
#      end
#    rescue
#      retry
#    end
#  end
#end
#
#n = 400_000
#puts "\n\n########## (often) exception handling in loop  ##########"
#Benchmark.bmbm do |bm|
#  bm.report("while begin rescue end end") do
#    i = 0
#    while true
#      begin
#        i += 1
#        break if i > n
#        raise "figg"
#      rescue
#        next
#      end
#    end
#  end
#
#  bm.report("begin while end rescue end") do
#    i = 0
#    begin
#      while true
#        i += 1
#        break if i > n
#        raise "figg"
#      end
#    rescue
#      retry
#    end
#  end
#end


#class Foo
#  def initialize a, b, c
#    @values = { a: a, b: b, c: c }
#  end
#
#  def a() @values[:a] end
#  def b() @values[:b] end
#  def c() @values[:c] end
#end
#
#class Bar
#  def initialize a, b, c
#    @a, @b, @c = a, b, c
#  end
#
#  def a() @a end
#  def b() @b end
#  def c() @c end
#end
#n = 10_000_000
#puts "\n\n########## single instance variables vs. one instance variable hash  ##########"
#Benchmark.bmbm do |bm|
#  bm.report("hash") do
#    o = Foo.new "hihi", "haha", "huhu"
#    n.times do
#      o.a
#      o.b
#      o.c
#    end
#  end
#
#  bm.report("instance variables") do
#    o = Bar.new "hihi", "haha", "huhu"
#    n.times do
#      o.a
#      o.b
#      o.c
#    end
#  end
#end

#n = 3_000_000
#puts "\n\n########## String#+ vs. String#<<  ##########"
#Benchmark.bmbm do |bm|
#  bm.report("String#+") do
#    n.times do
#      output = <<-OUTPUT + "and this is the prompt"
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      OUTPUT
#    end
#  end
#
#  bm.report("String#<<") do
#    n.times do
#      output = <<-OUTPUT << "and this is the prompt"
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      this is a big output line
#      OUTPUT
#    end
#  end
#end

#n = 10_000_000
#puts "\n\n########## String#[] and String#== vs. String#end_with?  ##########"
#Benchmark.bmbm do |bm|
#  s = "hehe bli hehe bla hehe"
#  bm.report("#end_with?") do
#    n.times do
#      s.end_with? "\n"
#    end
#  end
#
#  bm.report("#[] and #==") do
#    n.times do
#      s[-1] == "\n"
#    end
#  end
#end

#n = 30_000_000
#puts "\n\n########## unless vs. if not  ##########"
#Benchmark.bmbm do |bm|
#  s = "hehe bli hehe bla hehe"
#  bm.report("unless") do
#    n.times do
#      nil unless s
#    end
#  end
#
#  bm.report("if not") do
#    n.times do
#      nil if not s
#    end
#  end
#end

#n = 5_000_000
#puts %[\n\n########## "\#{bla}" vs. "%X" % bla  ##########]
#Benchmark.bmbm do |bm|
#  bm.report("interpolation with a string") do
#    n.times do
#      s = "blibla"
#      "this is a string with a string #{s}"
#    end
#  end
#
#  bm.report("format string with a string") do
#    n.times do
#      "this is a string with a string %s" % "blibla"
#    end
#  end
#
#  bm.report("interpolation with a number") do
#    n.times do
#      s = 5_000
#      "this is a string with a number #{s}"
#    end
#  end
#
#  bm.report("format string with a number") do
#    n.times do
#      "this is a string with a string %d" % 5_000
#    end
#  end
#end

n = 50_000
puts %[\n\n########## deleting the last line of a string  ##########]
Benchmark.bmbm do |bm|
  s = <<-STR
this is the command line which can be very long
#--------------------------------------------------------
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
#--------------------------------------------------------
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
this is some output which can be even looooooooooooooooooooooooooooooooooooooooooooonger
and this is the last line
  STR
  # FAST
  bm.report("String#lines (0...-1), Array#[] and #join") do
    n.times do
      s.lines.to_a[0...-1].join
    end
  end

  # FAST
  bm.report("String#lines (0..-2), Array#[] and #join") do
    n.times do
      s.lines.to_a[0..-2].join
    end
  end

#  # SLOW
#  bm.report("String#[]=") do
#    n.times do
#      new_str = s.dup
#      new_str[/.*\z/] = ""
#    end
#  end
#
#
#  # SLOW
#  bm.report("String#sub") do
#    n.times do
#      s.sub(/.*\z/, "")
#    end
#  end
end
