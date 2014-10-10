# PROOF OF CONCEPT
# ================
# * only one socket on the broker side
# * only one socket on the client side
# * both can talk asynchronously
# * CURVE encryption is used

require 'rbnacl'
require 'celluloid/zmq'
Celluloid::ZMQ.init

# Monkey patching
module Celluloid
  module ZMQ
    module ReadableSocket
      # Reads a multipart message, stores it into the given buffer and returns
      # the buffer.
      def read_multipart(buffer = [])
        ZMQ.wait_readable(@socket) if ZMQ.evented?

        unless ::ZMQ::Util.resultcode_ok? @socket.recv_strings buffer
          raise IOError, "error receiving ZMQ string: #{::ZMQ::Util.error_string}"
        end
        buffer
      end
    end

    module WritableSocket
      extend Forwardable
      def_delegator :@socket, :send_strings
    end
  end
end

server_key = RbNaCl::PrivateKey.generate
client_key = RbNaCl::PrivateKey.generate
SERVER_PRIVATE_KEY = server_key.to_bytes
SERVER_PUBLIC_KEY = server_key.public_key.to_bytes
CLIENT_PRIVATE_KEY = client_key.to_bytes
CLIENT_PUBLIC_KEY = client_key.public_key.to_bytes

# No ZAP authenticator is used, so no client authentication is done. All
# clients are allowed.

class Server
  include Celluloid::ZMQ
  include Celluloid::Logger
  def initialize
    @socket = RouterSocket.new
    @socket.identity = "server"
    @socket.set(::ZMQ::ZAP_DOMAIN, 'mydomain')
    @socket.set(::ZMQ::CURVE_SERVER, 1)
    @socket.set(::ZMQ::CURVE_SECRETKEY, SERVER_PRIVATE_KEY)
    @socket.bind("tcp://127.0.0.1:5555")
    async.receive_feedback
    async.send_work
  end
  def receive_feedback
    info "Server: Receiving feedback ..."
    loop do
      # first frame contains peer identity (added by RouterSocket)
      client, feedback = @socket.read_multipart
      info "Server: Got feedback from client #{client.inspect}: #{feedback.inspect}"
    end
  end
  def send_work
    info "Server: Sending work ..."
    every(2) do
      # first frame must contain peer identity (removed by RouterSocket)
      @socket.send_strings(["client", "Hello"])
    end
  end
end

class Client
  include Celluloid::ZMQ
  include Celluloid::Logger
  def initialize
    @socket = DealerSocket.new
    @socket.identity = "client"
    @socket.set(::ZMQ::ZAP_DOMAIN, 'mydomain')
    @socket.set(::ZMQ::CURVE_SERVERKEY, SERVER_PUBLIC_KEY)
    @socket.set(::ZMQ::CURVE_PUBLICKEY, CLIENT_PUBLIC_KEY)
    @socket.set(::ZMQ::CURVE_SECRETKEY, CLIENT_PRIVATE_KEY)
    @socket.connect("tcp://127.0.0.1:5555")
    async.receive_work
    async.send_feedback
  end
  def receive_work
    info "Client: Receiving work ..."
    loop do
      work = @socket.read
      info "Client: Got work: #{work.inspect}"
    end
  end
  def send_feedback
    info "Client: Sending feedback ..."
    every(2.5) do
      @socket.write "World"
    end
  end
end

Server.new
Client.new
sleep
