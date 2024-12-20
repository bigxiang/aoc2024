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

cheats = {}
point = start_point
while point != end_point
  i, j = point
  curr_step = travelled_matrix[i][j]

  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di, dj|
    cheat_i = i + di
    cheat_j = j + dj

    cheat_step = travelled_matrix[cheat_i][cheat_j]
    point = [cheat_i, cheat_j] if cheat_step.to_i > curr_step

    next if cheat_step != '#' ||
            cheat_i == 0 || cheat_i == matrix.size - 1 ||
            cheat_j == 0 || cheat_j == matrix[0].size - 1

    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di2, dj2|
      new_i = cheat_i + di2
      new_j = cheat_j + dj2
      new_step = travelled_matrix[new_i][new_j]

      next if [i, j] == [new_i, new_j] ||
              new_step == '#' ||
              cheats.key?([[i, j], [new_i, new_j]]) ||
              new_step <= curr_step + 2

      cheats[[[i, j], [new_i, new_j]]] = new_step - curr_step - 2
    end
  end
end

numed_cheats = cheats.each_with_object({}) do |(key, value), memo|
  memo[value] ||= []
  memo[value] << key
end

puts "cheats: #{numed_cheats}"

cheats_count = numed_cheats.each_with_object({}) do |(key, value), memo|
  memo[key] = value.size
end

puts "cheats count: #{cheats_count}"

valid_cheats_count = cheats_count.select { |key, value| key >= 100 }.values.sum
puts "valid cheats count: #{valid_cheats_count}"
