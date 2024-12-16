# lines = %w[
#   AAAA
#   BBCD
#   BBCC
#   EEEC
# ]

# lines = %w[
#   OOOOO
#   OXOXO
#   OOOOO
#   OXOXO
#   OOOOO
# ]

# lines = %w[
#   RRRRIICCFF
#   RRRRIICCCF
#   VVRRRCCFFF
#   VVRCCCJFFF
#   VVVVCJJCFE
#   VVIVCCJJEE
#   VVIIICJJEE
#   MIIIIIJJEE
#   MIIISIJEEE
#   MMMISSJEEE
# ]

# matrix = lines.map do |line|
#   line.split('')
# end

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
matrix = []
f.each_line do |line|
  matrix << line.strip.split('')
end

puts matrix.map(&:join).join("\n")

def visit(matrix, i, j, visited, regions, root)
  return if visited[i][j]

  visited[i][j] = true
  col = matrix[i][j]
  region_key = "#{col}#{root}"

  regions[region_key] ||= [0, 0]
  regions[region_key][1] += 1
  if i - 1 < 0 || matrix[i - 1][j] != col
    regions[region_key][0] += 1
  else
    visit(matrix, i - 1, j, visited, regions, root)
  end

  if j - 1 < 0 || matrix[i][j - 1] != col
    regions[region_key][0] += 1
  else
    visit(matrix, i, j - 1, visited, regions, root)
  end

  if i + 1 > matrix.size - 1 || matrix[i + 1][j] != col
    regions[region_key][0] += 1
  else
    visit(matrix, i + 1, j, visited, regions, root)
  end

  if j + 1 > matrix[0].size - 1 || matrix[i][j + 1] != col
    regions[region_key][0] += 1
  else
    visit(matrix, i, j + 1, visited, regions, root)
  end
end

regions = {}
visited = Array.new(matrix.size) { Array.new(matrix[0].size, false) }
matrix.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if visited[i][j]

    visit(matrix, i, j, visited, regions, "[#{i},#{j}]")
  end
end

puts regions.map { |_, (p, a)| p * a }.sum
