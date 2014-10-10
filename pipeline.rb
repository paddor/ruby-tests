#! /usr/local/bin/ruby19

require 'thread'

class PoorFiber
  class FiberError < StandardError; end
  def initialize
    p self
    raise ArgumentError, 'new Fiber requires a block' unless block_given?

    @yield = Queue.new
    @resume = Queue.new

    @thread = Thread.new{ @yield.push [ *yield(*@resume.pop) ] }
    @thread.abort_on_exception = true
    @thread[:fiber] = self
  end
  attr_reader :thread

  def resume *args
    raise FiberError, 'dead fiber called' unless @thread.alive?
    @resume.push(args)
    result = @yield.pop
    result.size > 1 ? result : result.first
  end

  def yield *args
    @yield.push(args)
    result = @resume.pop
    result.size > 1 ? result : result.first
  end

  def self.yield *args
    raise FiberError, "can't yield from root fiber" unless fiber = Thread.current[:fiber]
    fiber.yield(*args)
  end

  def self.current
    Thread.current[:fiber] or raise FiberError, 'not inside a fiber'
  end

  def inspect
    "#<#{self.class}:0x#{self.object_id.to_s(16)}>"
  end
end

class PipelineElement

  attr_accessor :source

  def initialize
    @fiber_delegate = Fiber.new do
#    @fiber_delegate = PoorFiber.new do
      process
    end
  end

  def |(other)
    p self
    other.source = self
    other
  end

  def resume
    @fiber_delegate.resume
  end

  def process
    while value = input
      handle_value(value)
    end
  end

  def handle_value(value)
    output(value)
  end

  def input
    source.resume
  end

  def output(value)
    Fiber.yield(value)
#    PoorFiber.yield(value)
  end
end

##
# The classes below are the elements in our pipeline
#
 class Evens < PipelineElement
   def process
     value = 0
     loop do
       output(value)
       value += 2
     end
   end
 end

class MultiplesOf < PipelineElement
  def initialize(factor)
    @factor = factor
    super()
  end
  def handle_value(value)
    output(value) if value % @factor == 0
  end
end

evens = Evens.new
multiples_of_three = MultiplesOf.new(3)
multiples_of_seven = MultiplesOf.new(7)

pipeline = evens | multiples_of_three | multiples_of_seven

25.times do
  puts pipeline.resume
end
