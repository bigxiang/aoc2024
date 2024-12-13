# lines = [
#   '............',
#   '........0...',
#   '.....0......',
#   '.......0....',
#   '....0.......',
#   '......A.....',
#   '............',
#   '............',
#   '........A...',
#   '.........A..',
#   '............',
#   '............'
# ]
# original_matrix = []
# lines.each do |line|
#   original_matrix << line.strip.split('')
# end

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
original_matrix = []
f.each_line do |line|
  original_matrix << line.strip.split('')
end

# puts original_matrix.size
# puts original_matrix[0].size
# puts original_matrix.map(&:join).join("\n")

antennas = {}
original_matrix.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    next if cell == '.'

    antennas[cell] ||= []
    antennas[cell] << [i, j]
  end
end

puts antennas

antenna_pairs = antennas.flat_map do |_frequency, positions|
  positions.combination(2).to_a
end

puts antenna_pairs.size
puts antenna_pairs[0].size
puts antenna_pairs[0].map { |pair| pair.join(',') }.join(':')

anti_nodes = Set.new
antenna_pairs.each do |pair|
  p1, p2 = pair.map(&:dup)

  puts '==='
  di = p1[0] - p2[0]
  dj = p1[1] - p2[1]
  puts "#{di}, #{dj}, #{p1}, #{p2}"

  while p1[0] >= 0 && p1[0] < original_matrix.size &&
        p1[1] >= 0 && p1[1] < original_matrix[0].size

    puts p1.join(',')
    anti_nodes.add(p1.dup)
    p1[0] += di
    p1[1] += dj
  end

  while p2[0] >= 0 && p2[0] < original_matrix.size &&
        p2[1] >= 0 && p2[1] < original_matrix[0].size

    puts p2.join(',')
    anti_nodes.add(p2.dup)
    p2[0] -= di
    p2[1] -= dj
  end
end

puts anti_nodes.size

puts anti_nodes.map { |node| node.join(',') }.join(':')
