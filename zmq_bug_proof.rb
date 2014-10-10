require 'ffi-rzmq'

# for https://github.com/chuckremes/ffi-rzmq/issues/115

class ZMQTest
  def initialize(addr)
    @ctx = ::ZMQ::Context.create
    @socket = @ctx.socket(::ZMQ::ROUTER)
    warn "setting option ::ZMQ::ROUTER_MANDATORY (#{::ZMQ::ROUTER_MANDATORY}) to 1"
    @socket.setsockopt(::ZMQ::ROUTER_MANDATORY, 1)
    @socket.bind(addr)
  end

  def test
    warn "sending message"
    @socket.send_strings(["test_client", "foo"])
  rescue
    warn "YAY!"
  else
    warn "BAD! Should have raised!"
  end
end

ZMQTest.new("inproc://server").test
