i = 0
while true
  i += 1
  s = "line %20i #{?. * 997}\n" % i # line of 1024 bytes
  puts s
  warn "popen generator: printed line #{i} (#{s.bytesize} bytes)"
end
