f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
matrix = []
f.each_line do |line|
  matrix << line.strip.split('')
end
puts matrix.size
puts matrix[0].size

def dfs(matrix, i, j, level, di, dj)
  case level
  when 3
    return 1 if matrix[i][j] == 'S'

    0

  when 2
    return 0 unless matrix[i][j] == 'A'

    if i + di >= 0 && j + dj >= 0 && i + di < matrix.size && j + dj < matrix[i].size
      return dfs(matrix, i + di, j + dj, level + 1, di, dj)
    end

    0

  when 1
    return 0 unless matrix[i][j] == 'M'

    if i + di >= 0 && j + dj >= 0 && i + di < matrix.size && j + dj < matrix[i].size
      return dfs(matrix, i + di, j + dj, level + 1, di, dj)
    end

    0

  else
    raise 'invalid level'
  end
end

count = 0
(0...matrix.size).each do |i|
  (0...matrix[i].size).each do |j|
    next if matrix[i][j] != 'X'

    count += dfs(matrix, i - 1, j - 1, 1, -1, -1) if i > 0 && j > 0
    count += dfs(matrix, i - 1, j, 1, -1, 0) if i > 0
    count += dfs(matrix, i - 1, j + 1, 1, -1, 1) if i > 0 && j < matrix[i].size - 1
    count += dfs(matrix, i, j - 1, 1, 0, -1) if j > 0
    count += dfs(matrix, i, j + 1, 1, 0, 1) if j < matrix[i].size - 1
    count += dfs(matrix, i + 1, j - 1, 1, 1, -1) if i < matrix.size - 1 && j > 0
    count += dfs(matrix, i + 1, j, 1, 1, 0) if i < matrix.size - 1
    count += dfs(matrix, i + 1, j + 1, 1, 1, 1) if i < matrix.size - 1 && j < matrix[i].size - 1
  end
end

puts count
