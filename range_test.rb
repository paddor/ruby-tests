#! /usr/local/bin/ruby

class Month
  include Comparable
  Names = %w(
    January
    February
    March
    April
    May
    June
    July
    August
    September
    November
    December
  )

  attr_reader :name, :index

  def initialize(name)
    @name = name
    raise ArgumentError, "unknown month name" unless Names.include?(name)
    @index = Names.index(name)
  end

  def succ
    next_name = Names[ @index + 1 ]
    raise RangeError, "no month left" if next_name.nil?
    Month.new(next_name)
  end

  def <=> other
    @index <=> other.index
  end
end

jan = Month.new("January")
p jan
may = Month.new("May")
p may
range = jan..may
p range
