#! /usr/local/bin/ruby
require 'eventmachine'
require 'strscan'
require 'fiber'
require 'timeout'

module EventMachine::Telnet
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
    c += "\n" unless c.end_with? "\n"
    send_data c
    warn "Client: Sent command #{c.inspect}. Yielding fiber control ..."
    f = Fiber.current
    timer = EventMachine::Timer.new(1) { f.resume(Timeout::Error.new) }
    c = lambda { |o| timer.cancel; f.resume(o) }
    @callbacks << c
    case ret = Fiber.yield
    when Exception
      @callbacks.delete(c)
      raise ret
    else
      return ret
    end
  end

  def unbind
    warn "Client: Disconnected from server."
  end
end

EventMachine.run do
    Fiber.new do
  EventMachine.connect 'localhost', 8000, EventMachine::Telnet do |c|
      puts c.cmd "foo"
      puts((c.cmd "bar" rescue "caught Timeout!"))
      c.send_data "quit"
  end
      warn "end of fiber reached"
    end.resume
  EM.add_periodic_timer(1) { EM.stop if EM.connection_count.zero? }
end
