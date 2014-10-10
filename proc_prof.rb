#! /usr/local/bin/ruby

script = <<SCRIPT
  a = "blibla"
  b = ''
SCRIPT

n = 5_000
p = eval "proc { #{script} }"
n.times { p.call }
