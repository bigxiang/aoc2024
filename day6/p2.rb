f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
original_matrix = []
f.each_line do |line|
  original_matrix << line.strip.split('')
end

# lines = [
#   '....#.....',
#   '.........#',
#   '..........',
#   '..#.......',
#   '.......#..',
#   '..........',
#   '.#..^.....',
#   '........#.',
#   '#.........',
#   '......#...'
# ]
# original_matrix = []
# lines.each do |line|
#   original_matrix << line.strip.split('')
# end

directions_map = {
  [-1, 0] => 'N',
  [0, 1] => 'E',
  [1, 0] => 'S',
  [0, -1] => 'W'
}

matrix = original_matrix.map(&:dup)

def patrol_successful?(matrix, m, n, dm, dn, directions_map)
  return true if matrix[m][n] == '^'

  cloned_matrix = matrix.map(&:dup)
  cloned_matrix[m][n] = directions_map.keys.index([dm, dn])

  while m >= 0 && n >= 0 && m < cloned_matrix.size && n < cloned_matrix[m].size
    if cloned_matrix[m][n] == '#' || [0, 1, 2, 3].include?(cloned_matrix[m][n])
      m -= dm
      n -= dn

      dm, dn = dn, -dm
      m += dm
      n += dn
      next
    end

    if cloned_matrix[m][n] == directions_map[[dm, dn]]
      # cloned_matrix[m][n] = 'X'
      # puts cloned_matrix.map.with_index { |row, i| "#{(i + 1).to_s.rjust(3, '0')}#{row.join('')}" }.join("\n")
      # puts "patrol failed: [#{m}, #{n}]"
      return false
    end

    cloned_matrix[m][n] = directions_map[[dm, dn]] unless directions_map.values.include?(cloned_matrix[m][n])

    m += dm
    n += dn
  end
  true
end

count = 0
obstacles = Set.new
(0...matrix.size).each do |i|
  (0...matrix[i].size).each do |j|
    next if matrix[i][j] != '^'

    puts "patrol start: [#{i}, #{j}]"

    m = i
    n = j
    dm = -1
    dn = 0

    while m >= 0 && n >= 0 && m < matrix.size && n < matrix[m].size
      if matrix[m][n] == '#'
        m -= dm
        n -= dn

        dm, dn = dn, -dm
        m += dm
        n += dn
        next
      end

      if matrix[m][n] != 'X'
        unless patrol_successful?(original_matrix, m, n, dm, dn,
                                  directions_map)
          count += 1
          obstacles.add([m, n])
        end

        matrix[m][n] = 'X'
      end

      m += dm
      n += dn
    end
  end
end

# puts original_matrix.map.with_index { |row, i| "#{(i + 1).to_s.rjust(3, '0')}#{row.join('')}" }.join("\n")
puts '===='
# puts matrix.map.with_index { |row, i| "#{(i + 1).to_s.rjust(3, '0')}#{row.join('')}" }.join("\n")
# puts obstacles.to_a.map { |p| p.join(', ') }.join("\n")
puts count
puts obstacles.size
