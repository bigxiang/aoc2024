f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
pairs = []
f.each_line do |line|
  pairs << line.split(/\s+/)
end

# puts pairs.size
# puts pairs[0].size
# puts pairs.transpose[0].size

rows = pairs.transpose.map { |row| row.map(&:to_i) }.map(&:sort)
# puts rows[0]
puts rows[1]

distance = []
rows[0].size.times do |i|
  distance << (rows[0][i] - rows[1][i]).abs
end

puts distance.sum
