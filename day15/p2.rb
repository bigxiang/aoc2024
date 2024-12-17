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
#   "#######\n",
#   "#...#.#\n",
#   "#.....#\n",
#   "#..OO@#\n",
#   "#..O..#\n",
#   "#.....#\n",
#   "#######\n",
#   "\n",
#   "<vv<<^^<<^^\n"
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

def wider(map)
  char_map = {
    '.' => ['.', '.'],
    '#' => ['#', '#'],
    'O' => ['[', ']'],
    '@' => ['@', '.']
  }
  map.map do |row|
    row.flat_map do |char|
      char_map[char]
    end
  end
end

# puts map.map { |r| r.join }.join("\n")
# puts movements.join

map = wider(map)

position = nil
map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col != '@'

    position = [i, j]
  end
end

puts map.map { |r| r.join }.join("\n")

def move_together(map, boxes, di, dj)
  puts "move together: #{boxes}, #{di}, #{dj}"
  next_walls = boxes.select do |box|
    map[box[0][0] + di][box[0][1] + dj] == '#' || map[box[1][0] + di][box[1][1] + dj] == '#'
  end

  puts "next walls: #{next_walls}"
  return if next_walls.any?

  blocker_boxes = boxes.flat_map.with_index do |box, i|
    blockers = []
    if map[box[0][0] + di][box[0][1] + dj] == '['
      blockers << [[box[0][0] + di, box[0][1] + dj], [box[0][0] + di, box[0][1] + dj + 1]]
    elsif map[box[0][0] + di][box[0][1] + dj] == ']' && i == 0
      blockers << [[box[0][0] + di, box[0][1] + dj - 1], [box[0][0] + di, box[0][1] + dj]]
    end

    if map[box[1][0] + di][box[1][1] + dj] == '['
      blockers << [[box[1][0] + di, box[1][1] + dj],
                   [box[1][0] + di, box[1][1] + dj + 1]]
    end
    blockers
  end.compact

  puts "blockers: #{blocker_boxes}"
  move_together(map, blocker_boxes, di, dj) if blocker_boxes.any?

  return unless blocker_boxes.all? do |box|
                  map[box[0][0]][box[0][1]] == '.' && map[box[1][0]][box[1][1]] == '.'
                end

  boxes.each do |box|
    map[box[0][0] + di][box[0][1] + dj] = map[box[0][0]][box[0][1]]
    map[box[0][0]][box[0][1]] = '.'

    map[box[1][0] + di][box[1][1] + dj] = map[box[1][0]][box[1][1]]
    map[box[1][0]][box[1][1]] = '.'
  end
end

def move(map, i, j, di, dj)
  next_i = i + di
  next_j = j + dj

  puts "check wall: #{i}, #{j} -> #{next_i}, #{next_j}"
  return [i, j] if map[next_i][next_j] == '#'

  puts "check box: #{next_i}, #{next_j}"
  if map[next_i][next_j] == '[' || map[next_i][next_j] == ']'
    if [1, -1].include?(dj)
      move(map, next_i, next_j, di, dj)
    elsif map[next_i][next_j] == '['
      move_together(map, [[[next_i, next_j], [next_i, next_j + 1]]], di, dj)
    else
      move_together(map, [[[next_i, next_j - 1], [next_i, next_j]]], di, dj)
    end
  end

  if map[next_i][next_j] == '.'
    puts "move: #{i}, #{j} -> #{next_i}, #{next_j}"
    map[next_i][next_j] = map[i][j]
    map[i][j] = '.'

    return [next_i, next_j]
  end

  puts "no move: #{i}, #{j}"
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
  puts "movement: #{movement}, #{i}, #{j} -> #{i + di_map[movement]}, #{j + dj_map[movement]}"
  position = move(map, i, j, di_map[movement], dj_map[movement])

  puts map.map { |r| r.join }.join("\n")
end

sum = 0
map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col != '['

    sum += 100 * i + j
  end
end

puts sum
