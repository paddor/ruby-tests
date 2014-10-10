module Foo
  class << self
    def init; @var = "cool" end
    attr_accessor :var
  end
end
