require 'bigdecimal'

class IntegrateSquare

  # precision (number of significant digits)
  P = 10

  # method names and their description
  Methods = {
    m1: "sum += dx * (dx * i) ** 2",
    m2: "sum += (dx * i) ** 2",
    m3: "sum += xi ** 2",
    m4: "y_total += y_left + y_right, xi=dx*i",
    m5: "y_total += y_left + y_right, xi+=dx",
    m6: "simpson",
  }

  def self.m1(a, b, n)
    area = BigDecimal.new('0', P)
    a,b,dx = a_b_dx(a,b,n)
    1.upto(n) do |i|
      area = area.add(dx.mult(dx.mult(i, P).power(2, P), P), P)
    end
    area
  end

  def self.m2(a, b, n)
    y_total = BigDecimal.new('0', P)
    a,b,dx = a_b_dx(a,b,n)
    1.upto(n) do |i|
      y_total = y_total.add(dx.mult(i, P).power(2, P), P)
    end
    y_total.mult(dx, P)
  end

  def self.m3(a, b, n)
    y_total = BigDecimal.new('0', P)
    a,b,dx = a_b_dx(a,b,n)
    xi = a.add(dx, P)
    while xi <= b
      y_total = y_total.add(xi.power(2, P), P)
      xi = xi.add(dx, P)
    end
    y_total.mult(dx, P)
  end

  def self.m4(a, b, n)
    y_total = BigDecimal.new('0', P)
    a,b,dx = a_b_dx(a,b,n)
    y_left = a.power(2, P)
    1.upto(n) do |i|
      xi = dx.mult(i, P)
      y_right = xi.power(2, P)
      y_total = y_total.add(y_left.add(y_right, P), P)
      y_left = y_right
    end
    y_total.div(2, P).mult(dx, P)
  end

  def self.m5(a, b, n)
    # FIXME: error has peak in n=18,22,24,27,28
    y_total = BigDecimal.new('0', P)
    a,b,dx = a_b_dx(a,b,n)
    y_left = a.power(2, P)
    xi = a.add(dx, P)
    while xi <= b
      y_right = xi.power(2, P)
      y_total = y_total.add(y_left.add(y_right, P), P)
      y_left = y_right
      xi = xi.add(dx, P)
    end
    y_total.div(2, P).mult(dx, P)
  end

  def self.m6(a, b, n) # Simpson
    raise "n must be even" unless n.even?
    y_total = BigDecimal.new('0', P)
    a,b,dx = a_b_dx(a,b,n)
    y_total = y_total.add(a.power(2, P), P)
    y_total = y_total.add(b.power(2, P), P)

    y_uneven = BigDecimal.new('0', P)
    1.upto(n/2) do |i|
      xi = dx.mult(2*i-1, P)
      y_uneven = y_uneven.add(xi.power(2, P), P)
    end
    y_total = y_total.add(y_uneven.mult(4, P), P)

    y_even = BigDecimal.new('0', P)
    1.upto(n/2-1) do |i|
      xi = dx.mult(2*i, P)
      y_even = y_even.add(xi.power(2, P), P)
    end
    y_total = y_total.add(y_even.mult(2, P), P)

    y_total.mult(dx, P).div(3, P)
  end

  private

  def self.a_b_dx(a,b,n)
    a = BigDecimal.new(a, P)
    b = BigDecimal.new(b, P)
    dx = b.sub(a, P).div(n, P)

    return a,b,dx
  end
end

##
# Compare presicions (error) in relation to n and find n where error starts
# growing the first time.
#
ErrorPrecision = 50
Correct = BigDecimal.new(Rational('1/3'), ErrorPrecision)
n_max = 20
a, b = '0', '1' # strings for BigDecimal
puts "a = #{a}, b = #{b}"
puts "correct = #{Correct.to_s("F")}"
puts "n_max = #{n_max}"
puts "precision = #{IntegrateSquare::P}"
puts "error precision = #{ErrorPrecision}"
previous_errors = {}
IntegrateSquare::Methods.keys.each do |method|
  previous_error = nil
  current_errors = {}
  1.upto(n_max) do |n|
    begin
      result = IntegrateSquare.send(method, a, b, n)
      error = -(Correct.sub(result, ErrorPrecision))
      current_errors[n] = error
      previous_error = previous_errors[n]
      factor = previous_error.div(error, ErrorPrecision) if previous_error
      puts "%3s(n = %5i): %75s %75s (%+.3f)" % [ method, n, result.to_s("F"), error.to_s("+F"), factor||0 ]

      # comment to see errors
      break if current_errors[n-1] and current_errors[n-1].abs <= error.abs
    rescue
      puts "%3s(n = %5i): FAILED" % [ method, n]
    end
  end
  previous_errors = current_errors
  puts "-" * 80
end

##
# Find minimum n required to have an error less than the threshold.
#
n_by_method = { }
puts "Finding minimum n required for small error."
threshold = BigDecimal.new('0.001', ErrorPrecision)
n_max = 10_000
a, b = '0', '1' # strings for BigDecimal
IntegrateSquare::Methods.each do |method,description|
  puts "trying #{method} ..."
  1.upto(n_max) do |n|
    begin
      result = IntegrateSquare.send(method, a, b, n)
      error = Correct.sub(result, ErrorPrecision).abs
  #      puts error.to_s("F")
      if error < threshold
        puts "#{method}: #{description}: n_min = #{n}"
        n_by_method[method] = n
        break
      end
    rescue
      puts "#{method}: #{description}: n_min = #{n} FAILED"
    end
  end

  if not n_by_method.key?(method)
    puts "Unable to find n for method #{method}."
  end
end

##
# Benchmark times required to find desired precision (with n specific to each
# method from the previous test).
#
require 'benchmark'
m = 1_000
puts "Benchmark to find minimum error for each method (#{m} times each)."
Benchmark.bmbm do |x|
  a, b = '0', '1' # strings for BigDecimal
  IntegrateSquare::Methods.each do |method,description|
    n = n_by_method[method]
    if n.nil?
      puts "Skipping #{method} because there's no n for it."
      next
    end
    x.report("#{method}: #{description}") do
      m.times do
        IntegrateSquare.send(method, a, b, n_by_method[method])
      end
    end
  end
end
