# lines = %w[
#   89010123
#   78121874
#   87430965
#   96549874
#   45678903
#   32019012
#   01329801
#   10456732
# ]

# maps = []
# lines.each do |line|
#   maps << line.split('').map(&:to_i)
# end

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
maps = []
f.each_line do |line|
  maps << line.strip.split('').map(&:to_i)
end

puts maps.map(&:join).join("\n")

def path_score(maps, i, j, curr, visited)
  return 0 if i < 0 || i >= maps.size || j < 0 || j >= maps[0].size

  return 0 if curr + 1 != maps[i][j]

  if curr == 8 && maps[i][j] == 9
    return 0 if visited.include?([i, j])

    visited.add([i, j])
    return 1
  end

  path_score(maps, i - 1, j, maps[i][j], visited) +
    path_score(maps, i + 1, j, maps[i][j], visited) +
    path_score(maps, i, j - 1, maps[i][j], visited) +
    path_score(maps, i, j + 1, maps[i][j], visited)
end

total = 0
maps.each_with_index do |row, i|
  row.each_with_index do |num, j|
    next if num != 0

    total += path_score(maps, i, j, -1, Set.new)
  end
end
puts total
