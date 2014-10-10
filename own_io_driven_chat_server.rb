require 'socket'

module EventEmitter
  def _callbacks
    @_callbacks ||= Hash.new { |h, k| h[k] = [] }
  end

  def on(type, &blk)
    _callbacks[type] << blk
    self
  end

  def emit(type, *args)
    _callbacks[type].each do |blk|
      blk.call(*args)
    end
  end
end

class IOLoop
  # List of streams that this IO loop will handle.
  attr_reader :streams

  def initialize
    @streams = []
  end

  # Low-level API for adding a Stream.
  def <<(stream)
    @streams << stream
    stream.on(:close) do
      @streams.delete(stream)
    end
  end

  # Some useful helpers:
  def io(io)
    stream = Stream.new(io)
    self << stream
    stream
  end

  def open(file, *args)
    io File.open(file, *args)
  end

  def connect(host, port)
    io TCPSocket.new(host, port)
  end

  def listen(host, port)
    server = Server.new(TCPServer.new(host, port))
    self << server
    server.on(:accept) do |stream|
      self << stream
    end
    server
  end

  # Start the loop by calling #tick over and over again.
  def start
    @running = true
    tick while @running
  end

  # Stop/pause the event loop after the current tick.
  def stop
    @running = false
  end

  def tick
    r, w = IO.select(@streams, @streams)
    r.each do |stream|
      stream.handle_read
    end

    w.each do |stream|
      stream.handle_write
    end
  end
end

class Stream
  # We want to bind/emit events
  include EventEmitter

  def initialize(io)
    @io = io
    # Store outgoing data in this String.
    @writebuffer = ""
  end

  # This tells IO.select what IO to check for readiness
  def to_io; @io end

  def <<(chunk)
    # Append to buffer; #handle_write is doing the actual writing.
    @writebuffer << chunk
  end

  def handle_read
    chunk = @io.read_nonblock(4096)
    emit(:data, chunk)
  rescue IO::WaitReadable
    # Oops, turned out the IO wasn't actually readable.
    # Nevermind, this is handled by the next tick.
  rescue EOFError, Errno::ECONNRESET
    # IO was closed
    emit(:close)
  end

  def handle_write
    return if @writebuffer.empty?
    length = @io.write_nonblock(@writebuffer)
    # Slice away the data that was successfully written.
    @writebuffer.slice!(0, length)
    # Emit "drain" event if there's nothing more to write.
    emit(:drain) if @writebuffer.empty?
  rescue IO::WaitWritable
  rescue EOFError, Errno::ECONNRESET
    emit(:close)
  end
end

class Server
  include EventEmitter

  def initialize(io)
    @io = io
  end

  def to_io; @io end

  def handle_read
    sock = @io.accept_nonblock
    emit(:accept, Stream.new(sock))
  rescue IO::WaitReadable
  end

  def handle_write
    # do nothing
  end
end

if $0 == __FILE__
  io = IOLoop.new

  class ChatServer
    def initialize
      @clients = []
      @client_id = 0
    end

    def <<(server)
      server.on(:accept) do |stream|
        add_client(stream)
      end
    end

    def add_client(stream)
      id = (@client_id += 1)
      send("User ##{id} joined\n")

      stream.on(:data) do |chunk|
        send("User ##{id} said: #{chunk}")
      end

      stream.on(:close) do
        @clients.delete(stream)
        send("User ##{id} left")
      end

      @clients << stream
    end

    def send(msg)
      @clients.each do |stream|
        stream << msg
      end
    end
  end

  server = ChatServer.new
  server << io.listen('0.0.0.0', 1234)

  io.start
end
