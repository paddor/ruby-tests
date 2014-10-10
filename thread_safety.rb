#! /usr/local/bin/ruby


100.times do
  @array = []
  1_000.times do
    Thread.new { @array << "bla" }
  end
  puts @array.size
end

