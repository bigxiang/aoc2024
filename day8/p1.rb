lines = [
  '............',
  '........0...',
  '.....0......',
  '.......0....',
  '....0.......',
  '......A.....',
  '............',
  '............',
  '........A...',
  '.........A..',
  '............',
  '............'
]
original_matrix = []
lines.each do |line|
  original_matrix << line.strip.split('')
end

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
