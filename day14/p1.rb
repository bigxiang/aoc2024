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

robots.each do |r|
  p, v = r

  i, j = p
  di, dj = v
  i = (i + 100 * di) % matrix.size
  j = (j + 100 * dj) % matrix[0].size
  r[0] = [i, j]

  matrix[i][j] = 0 if matrix[i][j] == '.'
  matrix[i][j] += 1
end

mid_i = matrix.size / 2
mid_j = matrix[0].size / 2

robot_counts = Array.new(4, 0)
matrix.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col == '.'

    if i < mid_i && j < mid_j
      robot_counts[0] += col
    elsif i < mid_i && j > mid_j
      robot_counts[1] += col
    elsif i > mid_i && j < mid_j
      robot_counts[2] += col
    elsif i > mid_i && j > mid_j
      robot_counts[3] += col
    end
  end
end

robots.each { |r| puts "p:#{r[0]}, v:#{r[1]}" }
puts matrix.map { |r| r.join }.join("\n")
puts robot_counts.reduce(&:*)
