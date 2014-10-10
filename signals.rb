#! /usr/bin/env ruby

0.upto(15) do |sig|
  trap sig do
    puts "sig: #{sig}"
  end
end

sleep
