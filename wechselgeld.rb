
class Warenautomat
  Available = {
    100  => 1,
    50   => 1,
    20   => 1,
    10   => 0,
    5    => 1,
    2    => 3,
    1    => 0,
    0.50 => 0,
    0.20 => 0,
    0.10 => 0,
    0.05 => 0,
  }

  class TooGreedy < StandardError
  end

  def initialize()
    @available = Available.dup
  end

  def amount_to_be_returned
    amount = 0
    @items_back.each do |value,count|
      amount += value * count
    end
    amount
  end

  def return_money(cost, given)
    puts "Available notes and coins:"
    print_items(@available, true)

    diff = given - cost
    puts "Trying to return: #{diff} CHF"

    @items_back = {}
    Available.keys.each {|k| @items_back[k] = 0 }

    calculate(diff)

    puts "Back:"
    print_items(@items_back)
  end

  private

  def calculate(amount)
    origin_amount = amount
    skip = 0
    begin
      available = @available.dup

      while amount_to_be_returned < origin_amount
        puts amount_to_be_returned
        possible = available.select { |v,c| c > 0 and amount >= v }.to_a[ skip .. -1 ]
        #raise "impossible" if possible.empty?
        raise TooGreedy if possible.nil? or possible.empty?
        possible.each do |value,count|
          required_count = amount / value
          rest = amount % value
          required_count = ((amount - rest) / value).to_i

          if required_count > available[value]
            raise "required count of #{value} coins/notes is not available"
          end

          @items_back[value] += required_count
          available[value] -= required_count
          amount -= required_count * value
        end
      end

      @available = available
    rescue TooGreedy
      puts "skip=#{skip}"
      skip += 1
      raise "impossible" if skip > available.size
      retry
    end
  end

  def print_items(items, print_all = false)
    items.each do |value,count|
      next if not print_all and count == 0
      unit = "CHF"
      if value.to_i != value
        value = value * 100
        unit = "rp"
      end
      puts "%15i%4s %10i" % [ value, unit, count ]
    end
    puts
  end
end

cost = ARGV[0].to_f
given = ARGV[1].to_f
w = Warenautomat.new
w.return_money(cost, given)
