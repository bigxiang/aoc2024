lines = %W[
  029A\n
  980A\n
  179A\n
  456A\n
  379A\n
]

# f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
# lines = f.readlines

codes = []
lines.each do |line|
  codes << line.chomp.chars
end

puts codes.map { |c| c.join }.join("\n")

numpad = [
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  ['#', '0', 'A']
]

numpad_map = {
  '7' => [0, 0],
  '8' => [0, 1],
  '9' => [0, 2],
  '4' => [1, 0],
  '5' => [1, 1],
  '6' => [1, 2],
  '1' => [2, 0],
  '2' => [2, 1],
  '3' => [2, 2],
  '0' => [3, 1],
  'A' => [3, 2]
}

dirpad = [
  ['#', '^', 'A'],
  ['<', 'v', '>']
]

dirpad_map = {
  '^' => [0, 1],
  'A' => [0, 2],
  '<' => [1, 0],
  'v' => [1, 1],
  '>' => [1, 2]
}

dir_map = {
  [0, 1] => '>',
  [0, -1] => '<',
  [1, 0] => 'v',
  [-1, 0] => '^'
}

def move(code, n, pad, pad_map, i, j, di, dj, dir_map, history, result)
  return if i < 0 || i >= pad.size || j < 0 || j >= pad[0].size
  return if pad[i][j] == '#'
  return if result.size > 0 && history.size >= result[0].size

  history << dir_map[[di, dj]] if dir_map.key?([di, dj])

  target = code[n]
  if pad[i][j] == target
    history << 'A'

    if n == code.size - 1
      if result.empty? || history.size == result[0].size
        result << history
      elsif history.size < result[0].size
        result.clear
        result << history
      end
    else
      move(code, n + 1, pad, pad_map, i, j, 0, 0, dir_map, history.dup, result)
    end
  else
    target_pos = pad_map[target]
    i_distance = target_pos[0] - i
    j_distance = target_pos[1] - j

    if i_distance != 0
      di = i_distance / i_distance.abs
      move(code, n, pad, pad_map, i + di, j, di, 0, dir_map, history.dup, result)
    end

    if j_distance != 0
      dj = j_distance / j_distance.abs
      move(code, n, pad, pad_map, i, j + dj, 0, dj, dir_map, history.dup, result)
    end
  end
end

def shortest_seq(code, pad, pad_map, dir_map)
  result = []

  move(code, 0, pad, pad_map, pad_map['A'][0], pad_map['A'][1], 0, 0, dir_map, [], result)

  result
end

sum = 0
codes.each do |code|
  r1_sequences = shortest_seq(code, numpad, numpad_map, dir_map)
  # puts r1_sequences.map { |r| r.join }.join("\n")

  r2_sequences = r1_sequences.flat_map do |s|
    shortest_seq(s, dirpad, dirpad_map, dir_map)
  end

  # puts r2_sequences.map { |r| r.join }.join("\n")

  r3_sequences = r2_sequences.flat_map do |s|
    shortest_seq(s, dirpad, dirpad_map, dir_map)
  end

  min_ops = r3_sequences.map(&:size).min
  num = code[0..code.size - 2].join.to_i

  sum += num * min_ops
  puts "#{num} * #{min_ops} = #{num * min_ops}"
end

puts sum
