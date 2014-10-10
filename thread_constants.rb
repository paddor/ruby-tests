A = "meine Konstante"
puts A
Thread.new do
  A << " und noch etwas"
  B = "blabla"
  puts B
end #.join

puts A
puts B
