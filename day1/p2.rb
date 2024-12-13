f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
pairs = []
f.each_line do |line|
  pairs << line.split(/\s+/)
end

# puts pairs.size
# puts pairs[0].size
# puts pairs.transpose[0].size

num_row, frequency_row = pairs.transpose.map { |row| row.map(&:to_i) }

frequency_map = frequency_row.each_with_object({}) do |frequency, memo|
  memo[frequency] = memo.fetch(frequency, 0) + 1
end

puts num_row.map { |num| num * frequency_map.fetch(num, 0) }.sum
