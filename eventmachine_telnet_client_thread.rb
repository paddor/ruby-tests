#! /usr/local/bin/ruby
$-d = $-v = true
require 'eventmachine'
require 'strscan'
require 'timeout'

module EventMachine::Telnet
  def self.new host, port, &blk
    unless EventMachine.reactor_running?
      Thread.new(Thread.current) do |t|
        EventMachine.run { t.wakeup }
      end
      Thread.stop
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
    c += "\n" unless c.end_with? "\n"
    send_data c
    warn "Client: Sent command #{c.inspect}. Yielding fiber control ..."
    t = Thread.current
    timer = EventMachine::Timer.new(3) { t.raise Timeout::Error }
    @callbacks << lambda { |o| timer.cancel; t[:output] = o; t.run }
    Thread.stop
    t[:output]
  end

  def unbind
    warn "Client: Disconnected from server."
  end
end

c = EventMachine::Telnet.new 'localhost', 8000
puts c.cmd "foo"
puts "eis"
puts c.cmd "bar"
puts "zwei"
puts c.send_data "quit"
puts "drue"
