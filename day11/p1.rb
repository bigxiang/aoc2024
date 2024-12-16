# stones = '125 17'.split(' ').map(&:to_i)
f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
stones = f.gets.strip.split(' ').map(&:to_i)
# stones = [2]

def digits(n)
  count = 1
  while (n /= 10) > 0
    count += 1
  end
  count
end

def blink(stones, n)
  n.times.each do
    new_stones = []
    stones.each do |stone|
      if stone.zero?
        new_stones << 1
      elsif (d = digits(stone)).even?
        new_stones << stone / (10**(d / 2))
        new_stones << stone % (10**(d / 2))
      else
        new_stones << stone * 2024
      end
    end
    stones = new_stones
  end
  stones
end

puts stones.map { |stone| blink([stone], 25) }.map(&:size).sum

# stones1 = blink(stones[0, 1], 25)
# stones2 = blink(stones[1, 1], 25)

# puts stones1.size + stones2.size
