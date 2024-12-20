# lines = [
#   "###############\n",
#   "#...#...#.....#\n",
#   "#.#.#.#.#.###.#\n",
#   "#S#...#.#.#...#\n",
#   "#######.#.#.###\n",
#   "#######.#.#...#\n",
#   "#######.#.###.#\n",
#   "###..E#...#...#\n",
#   "###.#######.###\n",
#   "#...###...#...#\n",
#   "#.#####.#.###.#\n",
#   "#.#...#.#.#...#\n",
#   "#.#.#.#.#.#.###\n",
#   "#...#...#...###\n",
#   "###############\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

matrix = []
lines.each do |line|
  matrix << line.chomp.split('')
end

start_point = nil
end_point = nil
matrix.each_with_index do |row, i|
  row.each_with_index do |c, j|
    start_point = [i, j] if c == 'S'
    end_point = [i, j] if c == 'E'
  end
end

puts "#{start_point} -> #{end_point}"

travelled_matrix = matrix.map(&:dup)
point = start_point
step = 0
while point != end_point
  i, j = point
  travelled_matrix[i][j] = step

  step += 1

  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di, dj|
    new_i = i + di
    new_j = j + dj

    point = [new_i, new_j] if travelled_matrix[new_i][new_j] == '.' || [new_i, new_j] == end_point
  end
end
travelled_matrix[end_point[0]][end_point[1]] = step

puts "final step: #{step}"

def bfs_find_cheats(travelled_matrix, cheats, i, j)
  curr_step = travelled_matrix[i][j]

  queue = [[i, j]]
  queue_i = 0
  time = 0
  visited = Set.new

  while queue_i < queue.size && time <= 20
    curr_step_size = queue.size

    while queue_i < curr_step_size
      cheat_i, cheat_j = queue[queue_i]
      cheat_step = travelled_matrix[cheat_i][cheat_j]
      queue_i += 1

      next if visited.include?([cheat_i, cheat_j])

      visited << [cheat_i, cheat_j]

      if cheat_step != '#' &&
         !cheats.key?([[i, j], [cheat_i, cheat_j]]) &&
         cheat_step > curr_step + time

        cheats[[[i, j], [cheat_i, cheat_j]]] = cheat_step - (curr_step + time)
      end

      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di, dj|
        new_i = cheat_i + di
        new_j = cheat_j + dj

        next if new_i < 0 || new_i > travelled_matrix.size - 1 ||
                new_j < 0 || new_j > travelled_matrix[0].size - 1

        queue << [new_i, new_j]
      end
    end

    time += 1
  end
end

cheats = {}
point = start_point
while point != end_point
  i, j = point

  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di, dj|
    new_i = i + di
    new_j = j + dj

    next if travelled_matrix[new_i][new_j].to_i <= travelled_matrix[i][j]

    point = [new_i, new_j]
  end

  bfs_find_cheats(travelled_matrix, cheats, i, j)
end

numed_cheats = cheats.each_with_object({}) do |(key, value), memo|
  memo[value] ||= []
  memo[value] << key
end

puts "cheats: #{numed_cheats[72]}"
puts "cheats: #{numed_cheats[74]}"

cheats_count = numed_cheats.each_with_object({}) do |(key, value), memo|
  memo[key] = value.size
end

puts "cheats count: #{cheats_count}"

valid_cheats_count = cheats_count.select { |key, value| key >= 100 }.values.sum
puts "valid cheats count: #{valid_cheats_count}"
