# lines = [
#   "###############\n",
#   "#.......#....E#\n",
#   "#.#.###.#.###.#\n",
#   "#.....#.#...#.#\n",
#   "#.###.#####.#.#\n",
#   "#.#.#.......#.#\n",
#   "#.#.#####.###.#\n",
#   "#...........#.#\n",
#   "###.#.#####.#.#\n",
#   "#...#.....#.#.#\n",
#   "#.#.#.###.#.#.#\n",
#   "#.....#...#.#.#\n",
#   "#.###.#.#.#.#.#\n",
#   "#S..#.....#...#\n",
#   "###############\n"
# ]

# lines = [
#   "#################\n",
#   "#...#...#...#..E#\n",
#   "#.#.#.#.#.#.#.#.#\n",
#   "#.#.#.#...#...#.#\n",
#   "#.#.#.#.###.#.#.#\n",
#   "#...#.#.#.....#.#\n",
#   "#.#.#.#.#.#####.#\n",
#   "#.#...#.#.#.....#\n",
#   "#.#.#####.#.###.#\n",
#   "#.#.#.......#...#\n",
#   "#.#.###.#####.###\n",
#   "#.#.#...#.....#.#\n",
#   "#.#.#.#####.###.#\n",
#   "#.#.#.........#.#\n",
#   "#.#.#.#########.#\n",
#   "#S#.............#\n",
#   "#################\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

map = []
lines.each do |line|
  map << line.chomp.chars
end

start_point = nil
end_point = nil
direction = [0, 1]
map_nav = map.map(&:dup)
map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next if col != 'S' && col != 'E'

    if col == 'S'
      start_point = [i, j]
      map[i][j] = [0, direction]
    end
    if col == 'E'
      end_point = [i, j]
      map[i][j] = '.'
    end
  end
end

puts map.map { |r| r.join }.join("\n")
puts "start: #{start_point}, end: #{end_point}"

queue = [[start_point, 0, direction]]
queue_i = 0
visited = Set.new
visited.add(queue[0])
while queue_i < queue.size
  curr_point, curr_cost, direction = queue[queue_i]
  queue_i += 1

  existing_cost, existing_direction = map[curr_point[0]][curr_point[1]]

  next if map[end_point[0]][end_point[1]] != '.' && curr_cost >= map[end_point[0]][end_point[1]][0]

  next if curr_point != start_point &&
          (existing_cost != '.' && curr_cost >= existing_cost && direction.map { |d| d * -1 } == existing_direction)

  map[curr_point[0]][curr_point[1]] = [curr_cost, direction]
  map_nav[curr_point[0]][curr_point[1]] =
    case direction
    when [0, 1]
      '>'
    when [0, -1]
      '<'
    when [1, 0]
      'V'
    when [-1, 0]
      '^'
    end

  if curr_point == end_point
    puts "reach end: #{curr_point}, cost: #{curr_cost}"

    next
  end

  [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |di, dj|
    # no turnaround
    next if -di == direction[0] && -dj == direction[1]

    # puts "checking: #{curr_point}, #{di}, #{dj}"

    i = curr_point[0] + di
    j = curr_point[1] + dj
    turn = di != direction[0] || dj != direction[1]
    cost = curr_cost + (turn ? 1001 : 1)
    step = [[i, j], cost, [di, dj]]

    if map[i][j] != '#' && !visited.include?(step)
      queue << step
      visited.add(step)
    end
  end
end

puts map_nav.map { |r| r.join }.join("\n")
puts map[end_point[0]][end_point[1]].join(',')
