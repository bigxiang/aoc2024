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

# lines = %w[
#   012345
#   123456
#   234567
#   345678
#   4.6789
#   56789.
# ]

# maps = []
# lines.each do |line|
#   maps << line.split('')
# end

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
maps = []
f.each_line do |line|
  maps << line.strip.split('')
end

puts maps.map(&:join).join("\n")

def path_rating(maps, i, j, curr)
  return 0 if i < 0 || i >= maps.size || j < 0 || j >= maps[0].size
  return 0 if maps[i][j] == '.'

  new_curr = maps[i][j].to_i

  return 0 if curr + 1 != new_curr

  return 1 if curr == 8 && new_curr == 9

  path_rating(maps, i - 1, j, new_curr) +
    path_rating(maps, i + 1, j, new_curr) +
    path_rating(maps, i, j - 1, new_curr) +
    path_rating(maps, i, j + 1, new_curr)
end

total = 0
maps.each_with_index do |row, i|
  row.each_with_index do |num, j|
    next if num != '0'

    total += path_rating(maps, i, j, -1)
  end
end
puts total
