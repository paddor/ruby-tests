#! /usr/local/bin/ruby
require 'coolio'
require 'strscan'
require 'fiber'
require 'timeout'

#$-d = true
#$-d = $-v = true
module Telnet

  class TimeoutTimer < Coolio::TimerWatcher
    def initialize interval
      super(interval)
      @fiber = Fiber.current
      #warn "Timer initialized!" if $-v
      attach Client::Loop
    end

    def on_timer
      #warn "Timer timed out!" if $-v
      detach
      #disable
      @fiber.resume(Timeout::Error.new)
    end
  end

  class Client < Coolio::TCPSocket
    Loop = Coolio::Loop.new

    def self.cool_connect opts={}, &blk
      host = opts[:host] || "localhost"
      port = opts[:port] || 8000

      Fiber.new do
        c = connect(host, port)
        c.attach Client::Loop
        #warn "Attached to event loop: #{c.inspect}" if $-v
        Fiber.yield c # will be resumed by #on_read
        blk.call(c) #yield c # exeute user block
        #warn "end of fiber reached" if $-v
      end.resume
    end

    attr_reader :buffer
    attr_accessor :prompt
    attr_reader :last_prompt

    def initialize(*)
      super
      @fiber = Fiber.current
      @timer = nil
    end

    def on_connect
      #warn "Connected to server." if $-v
      @buffer = StringScanner.new ""
      @seen_first_prompt = false
      @last_prompt = nil
      @prompt = /prompt>\z/
    end

    def on_connect_failed
      warn "connection failed"
    end

    def on_close
      #warn "Disconnected from server." if $-v
    end

    def on_read data
      #warn "Received data: #{data.inspect}." if $-v
      @buffer << data
      @timer.disable if @timer
      if @buffer.skip_until(@prompt)
        #warn "Prompt found!" if $-v
        @seen_first_prompt = true
        @last_prompt = @buffer.matched
        output = @buffer.pre_match
        @buffer.string = @buffer.post_match
        @fiber.resume(output) if @seen_first_prompt
      end
    end

    def cmd c
      c += "\n" unless c.end_with? "\n"
      write c
      #if $-v
        #warn "Sent command #{c.inspect}. Yielding fiber control ..."
      #end
      @timer = TimeoutTimer.new(3)
      ret = Fiber.yield
      raise ret if ret.is_a? Exception
      return(ret)
    end
  end
end

n = 1500
warn "opening #{n} connections ..."
n.times do
  Telnet::Client.cool_connect host: "::1" do |c|
    c.cmd("foo")
    begin
      c.cmd "bar"
    rescue Timeout::Error
      #warn "caught Timeout!"
    else
#      warn "figg!"
    end
    c.write "quit\n"
  end
end
warn "opened #{n} connections."

#class Coolio::Loop
#  attr_reader :active_watchers
#end

evloop = Telnet::Client::Loop
while evloop.has_active_watchers?
  evloop.run_once
end
