#! /usr/local/bin/ruby

while true
  print "What are you going to do today? "
  answer = gets
  if answer !~ /shut up/i
    puts "Great! I'm impressed ..."
    sleep 3
  else
    puts "OK, sorry. Bye"
    break
  end
end


