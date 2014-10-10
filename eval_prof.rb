#! /usr/local/bin/ruby

script = <<SCRIPT
  a = "blibla"
  b = ''
SCRIPT

n = 5_000
n.times { eval script }
