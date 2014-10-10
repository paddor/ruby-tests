class ATestClass

  attr_accessor :foo

  def initialize(foo = "default")
    @foo = foo    
  end

  def a_method
    puts "Entering a_method..."
    @bar = 3
    puts "@foo = #{@foo}"
  end

  def another_method
    @bar = 42
  end
end

a = ATestClass.new("some string")

a.a_method

a.another_method

puts "Done."
