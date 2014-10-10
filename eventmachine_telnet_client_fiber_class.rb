#! /usr/local/bin/ruby

$DEBUG = true
$VERBOSE = true

require 'eventmachine'
require 'strscan'
require 'fiber'

module EventMachine::Telnet
  def self.new host, port, &blk
    unless EventMachine.reactor_running?
      Thread.new { EventMachine.run }
      sleep 0.2 until EventMachine.reactor_running?
    end
    EventMachine.connect host, port, self, &blk
  end

  def post_init
    warn "Client: Connected to server."
    @buffer = StringScanner.new ""
    @callbacks = []
    @seen_first_prompt = false
    @last_prompt = nil
    @prompt = /prompt>/
  end

  attr_reader :buffer
  attr_accessor :prompt
  attr_reader :last_prompt

  def receive_data data
    warn "Client: Received data: #{data.inspect}."
    @buffer << data
    while @buffer.skip_until(@prompt)
      warn "Client: Prompt found!"
      @last_prompt = @buffer.matched
      @callbacks.shift.call(@buffer.pre_match) if @seen_first_prompt
      @buffer.string = @buffer.post_match
      @seen_first_prompt = true
    end
  end

  def cmd c
    f = Fiber.current
    @callbacks << lambda { |o| f.resume(o) }
    c += "\n" unless c.end_with? "\n"
    send_data c
    warn "Client: Sent command #{c.inspect}. Yielding fiber control ..."
    Fiber.yield
  end

  def unbind
    warn "Client: Disconnected from server."
  end
end

#EventMachine.run do
  #2.times do
    #EventMachine.connect 'localhost', 8000, EventMachine::Telnet do |c|
      Fiber.new do
        c = EventMachine::Telnet.new 'localhost', 8000
        puts c.cmd "bar"
        puts "eis"
        puts c.cmd "foo"
        puts "zwei"
        puts c.cmd "foo"
        puts "drue"
        puts c.cmd "quit"
        puts "vier"
        #EM.stop_event_loop
      end.resume
    #end
  #end
#end

#Thread.new { EventMachine.run }
#sleep 0.5 until EventMachine.reactor_running?
#Fiber.new do
#  EventMachine.connect 'localhost', 8000, EventMachine::Telnet do |c|
#    puts c.cmd "foo"
#    puts c.cmd "bar"
#    puts c.cmd "foo"
#    puts c.cmd "quit"
#    EM.stop_event_loop
#  end
#end.resume

#sleep 1 while EventMachine.reactor_running?
EventMachine.reactor_thread.join
