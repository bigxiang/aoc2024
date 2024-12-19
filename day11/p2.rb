# stones = '125 17'.split(' ').map(&:to_i)
f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
stones = f.gets.strip.split(' ').map(&:to_i)

def digits(n)
  count = 1
  while (n /= 10) > 0
    count += 1
  end
  count
end

stones_map = stones.each_with_object({}) do |stone, memo|
  memo[stone] ||= 0
  memo[stone] += 1
end

def blink(stones_map, n)
  n.times.each do
    new_stones_map = {}
    stones_map.keys.each do |stone|
      stone_count = stones_map[stone]
      if stone.zero?
        new_stones_map[1] = new_stones_map.fetch(1, 0) + stone_count
      elsif (d = digits(stone)).even?
        new_stones_map[stone / (10**(d / 2))] = new_stones_map.fetch(stone / (10**(d / 2)), 0) + stone_count
        new_stones_map[stone % (10**(d / 2))] = new_stones_map.fetch(stone % (10**(d / 2)), 0) + stone_count
      else
        new_stones_map[stone * 2024] = new_stones_map.fetch(stone * 2024, 0) + stone_count
      end
    end
    puts "new_stones_map: #{new_stones_map}"
    stones_map = new_stones_map.dup
  end
  stones_map
end

stones_map = blink(stones_map, 75)

# stones1 = blink(stones[0, 1], 25)
# stones2 = blink(stones[1, 1], 25)

puts stones_map
puts stones_map.values.sum
