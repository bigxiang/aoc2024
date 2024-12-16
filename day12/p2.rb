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
#   EEEEE
#   EXXXX
#   EEEEE
#   EXXXX
#   EEEEE
# ]

# lines = %w[
#   AAAAAA
#   AAABBA
#   AAABBA
#   ABBAAA
#   ABBAAA
#   AAAAAA
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

  regions[region_key] ||= [[], 0]
  regions[region_key][1] += 1
  if i - 1 < 0 || matrix[i - 1][j] != col
    regions[region_key][0] << [[i, j], [i, j + 1], 't']
  else
    visit(matrix, i - 1, j, visited, regions, root)
  end

  if j - 1 < 0 || matrix[i][j - 1] != col
    regions[region_key][0] << [[i, j], [i + 1, j], 'l']
  else
    visit(matrix, i, j - 1, visited, regions, root)
  end

  if i + 1 > matrix.size - 1 || matrix[i + 1][j] != col
    regions[region_key][0] << [[i + 1, j], [i + 1, j + 1], 'b']
  else
    visit(matrix, i + 1, j, visited, regions, root)
  end

  if j + 1 > matrix[0].size - 1 || matrix[i][j + 1] != col
    regions[region_key][0] << [[i, j + 1], [i + 1, j + 1], 'r']
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

puts regions

def count_lines(lines)
  count = 0
  lines.each_with_index do |line, i|
    next if i != 0 && line[0] == lines[i - 1][1] && line[2] == lines[i - 1][2]

    count += 1
  end
  count
end

price = 0
regions.each do |_, (lines, area)|
  i_lines = lines.select { |l| l[0][0] == l[1][0] }.sort { |a, b| [a[0], a[2]] <=> [b[0], b[2]] }
  puts i_lines.map { |l| "#{l[2]}#{l[0][0]},#{l[0][1]} -> #{l[1][0]},#{l[1][1]}" }.join(', ')

  j_lines =
    lines.select { |l| l[0][1] == l[1][1] }.sort { |a, b| [a[0][1], a[0][0], a[2]] <=> [b[0][1], b[0][0], b[2]] }
  puts j_lines.map { |l| "#{l[2]}#{l[0][0]},#{l[0][1]} -> #{l[1][0]},#{l[1][1]}" }.join(', ')

  lines_count = count_lines(i_lines) + count_lines(j_lines)
  puts "#{lines_count} #{area}"
  price += lines_count * area
end

puts price
