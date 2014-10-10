#! /usr/local/bin/ruby

require 'eventmachine'
require 'strscan'

module EventMachine::Telnet
  def post_init
    warn "Client: Connected to server."
    @buffer = StringScanner.new ""
    @seen_first_prompt = false
    @callbacks = []
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
      @callbacks.shift.(@buffer.pre_match) if @seen_first_prompt
      @buffer.string = @buffer.post_match
      @seen_first_prompt = true
    end
  end

  def cmd c, &b
    @callbacks << b
    c += "\n" unless c.end_with? "\n"
    send_data c
    warn "Client: Sent command #{c.inspect}."
  end

  def unbind
    warn "Client: Disconnected from server."
  end
end

EventMachine.run do
  EventMachine.connect 'localhost', 8000, EventMachine::Telnet do |c|
    c.cmd "foo" do |o|
      puts o
      c.cmd("bar") { |o| puts o }
      c.cmd("foo") { |o| puts o }
    end
  end
end
