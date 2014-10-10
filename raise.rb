def one
  raise "bla"
end

def two
  one
rescue TypeError
else $!=nil; raise "myerror"
end

two
