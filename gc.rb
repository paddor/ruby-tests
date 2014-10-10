destroyed_objects = 0
finalizer = proc { destroyed_objects += 1 } # in this scope no
# instance of MyObject is caught in the closure!!!
MyObject = Class::new( Object ) {
  define_method :initialize do
    ObjectSpace.define_finalizer self, finalizer
  end
}
a = Array.new(100_000){ MyObject.new }
GC.start

puts "Finalized objects #{destroyed_objects}"
a.each_index do |idx|
 a[idx] = nil
end
puts "Finalized objects #{destroyed_objects}"
GC.start
puts "Finalized objects #{destroyed_objects}"

existing_objects = 0
ObjectSpace.each_object( MyObject ) do
  existing_objects += 1
end
puts "Existing objects #{existing_objects}"
