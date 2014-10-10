#! /usr/local/bin/ruby
require 'eventmachine'

module ISAM
  Port = 23

  def post_init
    @buffer = ""
    @prompt = "prompt$ "
    @state = :waiting_for_login
    warn "Server: Client connected."
    send_login_prompt
  end

  def send_prompt
    send_data @prompt
    warn "Server: Prompt sent."
  end

  def send_login_prompt
    send_data "login: "
    warn "Server: Login prompt sent."
  end

  def send_password_prompt
    send_data "password: "
    warn "Server: Password prompt sent."
  end

  def receive_data data
    @buffer << data
    if logged_in?
      run_command
    elsif waiting_for_login?
      @username = @buffer.strip
      warn "Server: Username is #{@username.inspect}"
      @buffer.clear
      send_password_prompt
      @state = :waiting_for_passwd
    elsif waiting_for_passwd?
      @password = @buffer.chomp
      warn "Server: Password is #{@password.inspect}"
      if login_correct?
        warn "Server: Login successful."
        @state = :logged_in
        send_prompt
      else
        warn "Server: Login failed."
        @state = :waiting_for_login
        send_login_prompt
      end
      @buffer.clear
    end
  end

  def waiting_for_login?; @state == :waiting_for_login end
  def waiting_for_passwd?; @state == :waiting_for_passwd end
  def logged_in?; @state == :logged_in end
  def login_correct?; @username == "nocisam01" and @password == "pass04" end

  def unbind
    warn "Server: Client disconnected."
  end

  def send_command
    send_data @command
  end

  def run_command
    @command = @buffer.lines.first
    @buffer.clear
    case @command
    when /info configure system security operator flat/
      warn "Server: Client sent a real ISAM command #{@command.inspect}."
      send_command
      send_output <<-OUT
nocisam01 group noc bli bla lkdjsflksdjflsdjflsjdflsjdf
isadmin01 group admin bli bla lkdjsflksdjflsdjflsjdflsjdf
      OUT

    when /foo/
      warn "Server: Client sent command 'foo'."
      send_command
      send_output <<-OUT
This is the first output line of the command 'foo'.
This is the second output line of the command 'foo'.
This is the third output line of the command 'foo'.
      OUT
    when /bar/
      warn "Server: Client sent command 'bar'."
      EventMachine.add_timer 4 do
        send_command
        send_output <<-OUT
First line of the command 'bar'.
Second line of the command 'bar'.
Third line of the command 'bar'.
        OUT
      end
    when /quit|logout/
      warn "Server: Client sent command 'quit'."
      close_connection
    when /multi prompt/
      warn "Server: Client sent command 'multi prompt'."
      send_command
      send_output <<-OUT
This is the output for the first prompt.
      OUT
      EventMachine.add_timer 0.5 do
        send_output <<-OUT
This is the output for the second prompt.
        OUT
      end
    else
      warn "Server: Client sent some command #{@command.inspect}."
      send_command
      send_output <<-OUT
This is some example output.
      OUT
    end
  end

  def send_output output
    #send_data "\n"
    send_data output
    #send_data "\n#---------------------------------\n"
    send_prompt
  end
end

EventMachine.run do
  EventMachine.start_server 'localhost', ISAM::Port, ISAM
  warn "listening on port #{ISAM::Port}"
end
