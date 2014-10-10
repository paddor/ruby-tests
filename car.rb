#! /usr/local/bin/ruby

class Car

  # excetion raised when not enough fuel left to drive given distance
  class NotEnoughFuel < RuntimeError
  end

  # constructor with one parameter
  def initialize vendor
    @vendor = vendor # remember the vendor
    @fuel = 50 # initial amount of fuel
  end

  # create getter method for fuel
  attr_reader :fuel

  # manually create getter method for vendor
  def vendor
    @vendor
  end

  def empty?
    @fuel == 0 # returns true if @fuel is 0
  end

  def fill!
    @fuel = 50
  end

  # Drives _miles_ miles and returns the needed fuel.
  def drive miles
    # this car drives 10 miles per fuel unit
    needed_fuel = miles / 10.0
    raise NotEnoughFuel if @fuel < needed_fuel
    @fuel -= needed_fuel
    puts "Car just drove #{miles} miles and needed #{needed_fuel} fuel."
    return needed_fuel # 'return' is optional here
  end
end

# if this file was executed on its own (not loaded as a library)
if $0 == __FILE__

  my_car = Car.new "Ford"
  my_car.drive 55
  puts "Fuel left: #{my_car.fuel}"

  begin
    # do forever
    loop do
      # will raise after a few runs...
      my_car.drive 38
    end
  rescue Car::NotEnoughFuel
    puts "Oh shit! Not enough fuel!"
  end

  puts "The end."
end
