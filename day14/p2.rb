# lines = [
#   "p=0,4 v=3,-3\n",
#   "p=6,3 v=-1,-3\n",
#   "p=10,3 v=-1,2\n",
#   "p=2,0 v=2,-1\n",
#   "p=0,0 v=1,3\n",
#   "p=3,0 v=-2,-2\n",
#   "p=7,6 v=-1,-3\n",
#   "p=3,0 v=-1,-2\n",
#   "p=9,3 v=2,3\n",
#   "p=7,3 v=-1,2\n",
#   "p=2,4 v=2,-3\n",
#   "p=9,5 v=-3,-3\n"
# ]

# matrix = Array.new(7) { Array.new(11, '.') }

matrix = Array.new(103) { Array.new(101, '.') }
robots = []

LINE_PATTERN = /p=(\d+,\d+) v=(-*\d+,-*\d+)/
# lines.each do |line|
#   p, v = line.match(LINE_PATTERN).captures.map { |c| c.split(',').map(&:to_i).reverse }
#   robots << [p, v]
# end

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
f.each_line do |line|
  p, v = line.match(LINE_PATTERN).captures.map { |c| c.split(',').map(&:to_i).reverse }
  robots << [p, v]
end

def patrol(matrix, robots, times)
  robots.each do |r|
    p, v = r

    i, j = p
    di, dj = v
    i = (i + times * di) % matrix.size
    j = (j + times * dj) % matrix[0].size

    matrix[i][j] = '#' if matrix[i][j] == '.'
  end

  match = false
  matrix.each_with_index do |row, i|
    cnt = 0
    row.each_with_index do |col, j|
      if col == '.'
        cnt = 0
      else
        cnt += 1
      end

      if cnt > 15
        match = true
        break
      end
    end

    break if match
  end

  return unless match

  puts "after #{times} seconds"
  puts matrix.map { |r| r.join }.join("\n")
end

(0..10_000).each do |i|
  test_matrix = matrix.map(&:dup)

  patrol(test_matrix, robots, i)
end
