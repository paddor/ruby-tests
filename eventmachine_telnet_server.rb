#! /usr/local/bin/ruby
require 'eventmachine'

module TelnetServer
  def post_init
    @buffer = ""
    @prompt = "prompt>"
    warn "Server: Client connected."
    send_prompt
  end

  def send_prompt
    send_data @prompt
  end

  def receive_data data
    @buffer << data
    @buffer.each_line do |cmd|
      case cmd
      when /foo/
        warn "Server: Client sent command 'foo'."
        @buffer = ""
        send_data <<OUT
>>>> This is the first output line of the command 'foo'.
>>>> This is the second output line of the command 'foo'.
>>>> This is the third output line of the command 'foo'.
OUT
        send_prompt
        warn "Server: Sent output and prompt."
      when /bar/
        warn "Server: Client sent command 'bar'."
        @buffer = ""
        EventMachine.add_timer 4 do
          send_data <<OUT
>>>> First line of the command 'bar'.
>>>> Second line of the command 'bar'.
>>>> Third line of the command 'bar'.
OUT
          send_prompt
        end
      when /quit/
        warn "Server: Client sent command 'quit'."
        close_connection
      end
    end
  end

  def unbind
    warn "Server: Client disconnected."
  end
end

EventMachine.run do
  EventMachine.start_server 'localhost', 8000, TelnetServer
end
