class Foo
  # @return [Hash<rolename String, settings Hash>] hehe haha
  DEFAULT = { "Hua" => { bli: :bla }}

  # @return [Array<(String, Task)>] if there's at least one work host remaining
  # @return [nil] if there's no work hosts remaining
  def foo
    return [host, task]
  end

  BAR = 848

  # @example Awesome:
  #  foo.bar
  # @param opts [Hash] awesome options
  # @option opts [Integer] :bar (BAR) the amount of bar {BAR} BAR
  # @example direct usage of opts
  #  foo.bar bar: :hehe 
  def bar(opts={})
  end

  # @param blk block used as action
  # @yieldparam a [Integer] number a
  # @yieldparam b [Symbol] name of b
  def huhu(a, b=:b, &blk)
    yield a, b
  end

  class Hehe
  end


  # Creates a {Hehe}.
  # @see #huhu
  def hehe
    Hehe.new
  end

  # @return [Array<String>] names of your ancestors
  # @return [nil] if you're Adam or Eve
  def hihi
  end

  # @return [Mother]
  # @yieldparam a [Integer]
  # @yieldparam b [String]
  attr_reader :mamma

  # @param board_number [String] the <em>board number</em>
  # @return [Array<String>] the +board_number+
  def hehe board_number
    return [board_number]
  end
end
