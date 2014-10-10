require 'securerandom'

# Useful for Infsi1 at HSR
#
# Can I deduct the length of the original (random) text just from its
# autocorrelation (number of matching characters after rotation) and knowing
# the alphabet size?


# Very bad RNG for testing. It ignores the last 2 characters in alphabet.
class BadRNG
  def rand(n)
    return Kernel.rand(n-2)
  end
end

class SecureRNG
  def rand(n)
    return SecureRandom.random_number(n)
  end
end

# Using the operating system's Yarrow PRNG by reading from /dev/random
class DevRandom
  def initialize
    @source = File.open("/dev/random", "rb")
  end

  BLOCK_SIZE = 128 # how much to read at once

  def bytes
    @bytes ||= Enumerator.new do |y|
      while true
#        puts "reading #{BLOCK_SIZE} bytes from source ..."
        numbers = @source.read(BLOCK_SIZE).unpack("C*")
#        puts "got #{numbers.size} numbers from source: #{numbers.inspect}"
        numbers.each {|n| y << n}
      end
    end
  end

  def rand(n)
    byte = bytes.next
#    puts "got byte #{byte}"
    byte % n
  end
end


TEXT_LENGTH = 10_000
alphabet = ("A".."Z").to_a

#rng = Random # same as default
#rng = BadRNG.new
rng = SecureRNG.new # using SecureRandom
#rng = DevRandom.new # using /dev/random
text = (1..TEXT_LENGTH).map { alphabet.sample(random: rng) }

#puts text.join
#puts

correlations = []
rot = text.dup

# cycle through 
[text.size - 1, 500].min.times do |i|
  rot.rotate!
#  puts rot.join

  # measure correlation
  correlation = 0
  rot.zip(text) { |r,a| correlation += 1 if r==a }
#  puts "rotation by #{i+1}: #{correlation} matches"
  correlations << correlation
end

avg = correlations.inject(:+) / correlations.size
puts "average number of matches: #{avg}"
puts "length of original text: #{text.size}"
puts "length of alphabet: #{alphabet.size}"

guessed_length = avg * alphabet.size
puts "guessed length of original text (#{avg} * #{alphabet.size}): #{guessed_length}"

accuracy = 100 - ((text.size - guessed_length).abs.to_f / text.size * 100)
puts "accuracy: %.3f%" % accuracy
