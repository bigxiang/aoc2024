# lines = [
#   "5,4\n",
#   "4,2\n",
#   "4,5\n",
#   "3,0\n",
#   "2,1\n",
#   "6,3\n",
#   "2,4\n",
#   "1,5\n",
#   "0,6\n",
#   "3,3\n",
#   "2,6\n",
#   "5,1\n",
#   "1,2\n",
#   "5,5\n",
#   "2,5\n",
#   "6,5\n",
#   "1,4\n",
#   "0,4\n",
#   "6,4\n",
#   "1,1\n",
#   "6,1\n",
#   "1,0\n",
#   "0,5\n",
#   "1,6\n",
#   "2,0\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

points = []

lines.each do |line|\
  points << line.chomp.split(',').map(&:to_i).reverse
end

matrix = Array.new(71) { Array.new(71, '.') }

# 1024.times do |i|
#   matrix[points[i][0]][points[i][1]] = '#'
# end

puts matrix.map { |r| r.join }.join("\n")

def find_exit?(matrix)
  start_point = [0, 0]
  end_point = [matrix.size - 1, matrix[0].size - 1]

  queue = [start_point]
  queue_i = 0
  visited = Set.new
  steps = 0
  found = false
  while queue_i < queue.size
    (queue.size - queue_i).times do
      curr_point = queue[queue_i]
      queue_i += 1

      next if visited.include?(curr_point)

      visited.add(curr_point)

      matrix[curr_point[0]][curr_point[1]] = 'O'

      if curr_point == end_point
        puts 'Found the end point'
        found = true
        break
      end

      i, j = curr_point
      [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |di, dj|
        new_i = i + di
        new_j = j + dj

        unless new_i >= 0 && new_i < matrix.size && new_j >= 0 && new_j < matrix[0].size && matrix[new_i][new_j] == '.'
          next
        end

        queue << [new_i, new_j]
      end
    end

    break if found

    steps += 1
  end

  found
end

lo = 0
hi = points.size - 1
while lo < hi
  mid = (lo + hi) / 2

  test_matrix = matrix.map { |r| r.dup }
  (0..mid).each do |i|
    test_matrix[points[i][0]][points[i][1]] = '#'
  end

  if find_exit?(test_matrix)
    lo = mid + 1
  else
    hi = mid
  end
end
puts points[hi]

# puts matrix.map { |r| r.join }.join("\n")
