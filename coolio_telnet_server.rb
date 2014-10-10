#! /usr/local/bin/ruby
require 'coolio'
module Telnet
  class ActionTimer < Coolio::TimerWatcher
    def initialize interval, &action
      super(interval)
      @action = action
      attach Server::Loop
    end

    def on_timer
      detach
      @action.call
    end
  end

  class Server < Coolio::TCPSocket
    Loop = Coolio::Loop.new

    def on_connect
      @buffer = ""
      @prompt = "prompt>"
      warn "Client connected."
      send_prompt
    end

    def on_close
      warn "Client disconnected."
    end

    def on_read data
      @buffer << data
      @buffer.each_line do |cmd|
        cmd.chomp!
        case cmd
        when "foo"
          warn "Client sent command #{cmd.inspect}."
          write <<-OUT
>>>> foo output
          OUT
          send_prompt
          warn "Sent output and prompt."
        when "bar"
          warn "Client sent command #{cmd.inspect}."
#          ActionTimer.new 4 do
            write <<-OUT
>>>> bar output
            OUT
            send_prompt
#          end
        when "quit"
          warn "Client sent command #{cmd.inspect}."
          close
        else
          warn "Client sent unknown command #{cmd.inspect}"
          write <<-OUT
>>>> Unknown command #{cmd.inspect}.
          OUT
          send_prompt
        end
      end
      @buffer = ""
    end

    def send_prompt
      write @prompt
    end

    def warn str
      #Kernel.warn "#{remote_addr}:#{remote_port} #{str}"
    end
  end
end

server = Coolio::TCPServer.new "localhost", 8000, Telnet::Server
server.attach Telnet::Server::Loop
Telnet::Server::Loop.run
