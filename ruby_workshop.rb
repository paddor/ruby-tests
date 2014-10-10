# Various code snippets used in a Ruby workshop I once lead.

class Car

  def initialize continent
    @continent = continent
    @distance = 0.0
  end

  def drive km, unit=:km
    if unit == :km
      @distance += km
    else
      @distance += km * 0.62
    end
  end

  def distance
    if @continent == :America
      @distance * 0.62
    else
      @distance
    end
  end
end


c = Car.new :America
c.drive 30
c.drive 30, :miles
c.distance

c = Car.new :Europe
c.drive 20
c.drive 30, :miles
c.distance

class Vehicle
end

class Truck < Vehicle
end

class Car < Vehicle
end

class Cab < Car
end

class Van < Car
end


puts "Truck is a #{Truck.superclass}"
puts "Van's superclasses are: #{Van.ancestors}"
puts "Cab's superclasses are: #{Cab.ancestors}"

class Kurs
  include Enumerable
  attr_reader :teilnehmer

  def initialize
    @teilnehmer = []
  end

  def each
    @teilnehmer.sort.reverse.each { |tn| yield tn }
  end
end

k = Kurs.new

%w[ Kaspar Beni Rene Reto Matthias
  Robi Joerg Hanspeter Beat Silka Paddy ].each do |name|
  k.teilnehmer << name
end


k.each { |tn| puts tn }
puts "-" * 20
puts k.map { |tn| tn.upcase }

puts k.count


subscriber.all? { |s| s.online? } #=> true/false


a = [ 1, 2, 7, 9 ]
a = %w(cat dog)
p a
#sum = a.inject do |sum,n|
#  sum.+(n)
#end
sum = a.inject(:+)
puts "sum is #{sum}"

sum = a.first
a[1..-1].each do |e|
  sum = sum + e
end
puts "sum is #{sum}"


while true
  line = Kernel.gets
  if line =~ /start/ .. line =~ /end/
    puts "you typed: #{line}"
  end
end
