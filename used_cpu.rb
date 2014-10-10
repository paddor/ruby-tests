20.times do
  Thread.new do
    loop do
      i = 3
      5_000.times do i *= 5 end
    end
  end
end
sleep
