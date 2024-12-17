# lines = [
#   "##########\n",
#   "#..O..O.O#\n",
#   "#......O.#\n",
#   "#.OO..O.O#\n",
#   "#..O@..O.#\n",
#   "#O#..O...#\n",
#   "#O..O..O.#\n",
#   "#.OO.O.OO#\n",
#   "#....O...#\n",
#   "##########\n",
#   "\n",
#   "<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^\n",
#   "vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v\n",
#   "><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<\n",
#   "<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^\n",
#   "^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><\n",
#   "^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^\n",
#   ">^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^\n",
#   "<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>\n",
#   "^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>\n",
#   "v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^\n"
# ]

# lines = [
#   "########\n",
#   "#..O.O.#\n",
#   "##@.O..#\n",
#   "#...O..#\n",
#   "#.#.O..#\n",
#   "#...O..#\n",
#   "#......#\n",
#   "########\n",
#   "\n",
#   "<^^>>>vv<v>>v<<\n"
# ]

map = []
movements = []

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

lines.each do |line|
  if line[0] == '#'
    map << line.chomp.chars
  elsif line != "\n"
    movements += line.chomp.chars
  end
end

# puts map.map { |r| r.join }.join("\n")
# puts movements.join

position = nil
map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col != '@'

    position = [i, j]
    map[i][j] = '.'
  end
end

puts map.map { |r| r.join }.join("\n")

def move(map, i, j, di, dj)
  next_i = i + di
  next_j = j + dj

  # puts "check wall: #{i}, #{j} -> #{next_i}, #{next_j}, #{di}, #{dj}"
  return [i, j] if map[next_i][next_j] == '#'

  # puts "check box: #{next_i}, #{next_j}"
  move(map, next_i, next_j, di, dj) if map[next_i][next_j] == 'O'

  if map[next_i][next_j] == '.'
    if map[i][j] == 'O'
      # puts "move box: #{i}, #{j} -> #{next_i}, #{next_j}"
      map[i][j] = '.'
      map[next_i][next_j] = 'O'
    end

    return [next_i, next_j]
  end

  # puts "no move: #{i}, #{j}"
  [i, j]
end

di_map = Hash.new(0)
di_map.merge!(
  '^' => -1,
  'v' => 1
)

dj_map = Hash.new(0)
dj_map.merge!(
  '<' => -1,
  '>' => 1
)

movements.each do |movement|
  i, j = position
  # puts "movement: #{movement}, #{i}, #{j} -> #{i + di_map[movement]}, #{j + dj_map[movement]}"
  position = move(map, i, j, di_map[movement], dj_map[movement])
end

puts map.map { |r| r.join }.join("\n")

sum = 0
map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col != 'O'

    sum += 100 * i + j
  end
end

puts sum
