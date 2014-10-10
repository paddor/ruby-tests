require 'benchmark'

Words = %w[
  AAA Achtung Alge Baum Bier Clown Danke Dehnung Ding
  Donut Du Falco Fechten Fichte Foyer Funken Ganze
  Generisch Ghandi Gollum Gummi Gurmet Halli Hallo Hehe
  Hexe Ho Hunter Kahl Keller Kohl Kurz Kummer Lang
  Lamborghini Lettuce Lombardo Mam Maria Meer Mia Mom
  Mum Patrick Patrik Peer Politik Pollos Pumba Qualle Quartz
  Somophore Spass Speer Spiel Suppe Text Textile Tree
  Uganda Ulrich Umbrella Unit Vaud Vi Vogel Wahl Wal
  Welt Xandros Xavier Yxa Zander Zimmer Zorro Zumba
]
Words.each.with_index do |e,i|
  puts "#{i} => #{e}"
end
puts

class Array
  def bin_find_index(other)
    #puts "size=#{size}"
    if size == 1
      return nil if self[0] != other
    end
    middle_index = (size - 1) / 2
    middle_element = self[middle_index]
    if middle_element < other
      ret = self[middle_index+1..-1].bin_find_index(other)
      return ret if ret.nil?
      return middle_index + 1 + ret
    elsif middle_element > other
      return nil if middle_index == 0
      return self[0..middle_index-1].bin_find_index(other)
    elsif middle_element == other
      return middle_index
    else
      raise "should never occur"
    end
  end
end

NotExisting = %w[ Never Occur Exists Not-Good ]

(Words + NotExisting).each do |c|
  puts "#{c} => #{Words.bin_find_index(c).inspect}"
  #sleep 1
end

Benchmark.bmbm do |x|
  n = 20_000
  x.report "Array#find_index" do
    n.times do
      Words.find_index("Unit")
    end
  end

  x.report "Array#find_index { .. }" do
    n.times do
      Words.find_index { |w| w == "Unit" }
    end
  end

  x.report "Array#bin_find_index" do
    n.times do
      Words.bin_find_index("Unit")
    end
  end
end
