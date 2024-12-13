f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
matrix = []
f.each_line do |line|
  matrix << line.strip.split('')
end
puts matrix.size
puts matrix[0].size

count = 0
(0...matrix.size).each do |i|
  (0...matrix[i].size).each do |j|
    next if matrix[i][j] != 'A'
    next if i - 1 < 0 || j - 1 < 0 || i + 1 > matrix.size - 1 || j + 1 > matrix[i].size - 1

    left_up = matrix[i - 1][j - 1]
    left_down = matrix[i + 1][j - 1]
    right_up = matrix[i - 1][j + 1]
    right_down = matrix[i + 1][j + 1]

    if (left_up == 'M' && right_down == 'S' || left_up == 'S' && right_down == 'M') &&
       (left_down == 'M' && right_up == 'S' || left_down == 'S' && right_up == 'M')
      count += 1
    end
  end
end

puts count
