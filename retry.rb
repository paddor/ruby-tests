#! /usr/bin/env ruby
durchgang = 1
for i in 1..10
  puts i
  if i == durchgang
    puts "-" * 10
    durchgang += 1
    retry unless i == 10
  end
end
