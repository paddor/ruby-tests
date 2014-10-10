# Newton's method
def sqrt(radix, est_x, est_y)
  puts "-" * 80
  puts "Calculating square root of #{radix} with estimation #{est_y} for input #{est_x}"

  sqrt = est_y + (1.0 / (2 * est_y)) * (radix - est_x)
  puts "New approximation: #{sqrt}"

  return if sqrt == est_y
  sleep 0.5
  sqrt(radix, sqrt**2, sqrt)
end

sqrt(*ARGV.map {|e| Float e })
