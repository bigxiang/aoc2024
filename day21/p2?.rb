# lines = %W[
#   029A\n
#   980A\n
#   179A\n
#   456A\n
#   379A\n
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

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
  '#' => [3, 0],
  '0' => [3, 1],
  'A' => [3, 2]
}

dirpad = [
  ['#', '^', 'A'],
  ['<', 'v', '>']
]

dirpad_map = {
  '#' => [0, 0],
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

def shortest_seq(code, pad, pad_map)
  # puts "code: #{code}"
  result = []

  start_point = pad_map['A']
  sharp_point = pad_map['#']
  code.each do |c|
    steps = []
    target = pad_map[c]
    i_distance = target[0] - start_point[0]
    j_distance = target[1] - start_point[1]

    # puts "i_distance: #{i_distance}, j_distance: #{j_distance}"

    if start_point[0] == sharp_point[0] && target[1] == sharp_point[1]
      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end

      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end
    elsif start_point[1] == sharp_point[1] && target[0] == sharp_point[0]
      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end

      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end
    elsif j_distance == 0
      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end
    elsif i_distance == 0
      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end
    elsif j_distance < 0
      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end

      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end
    elsif i_distance > 0
      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end

      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end
    elsif j_distance > 0
      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end

      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end
    else
      i_distance.abs.times do
        steps << (i_distance > 0 ? 'v' : '^')
      end

      j_distance.abs.times do
        steps << (j_distance > 0 ? '>' : '<')
      end
    end

    steps << 'A'
    result << steps
    start_point = target
  end

  result.flatten
end

sum = 0
codes.each do |code|
  r_sequences = shortest_seq(code, numpad, numpad_map)
  puts r_sequences.join

  # 1.times do
  #   r_sequences = r_sequences.flat_map do |s|
  #     shortest_seq(s, dirpad, dirpad_map, dir_map)
  #   end
  # end

  r_sequences = '<^^^AvvvA>^AvA'.split('')
  # r_sequences = shortest_seq(r_sequence, dirpad, dirpad_map, dir_map)

  # puts r_sequences.map { |r| r.join }.join("\n")

  1.times do
    r_sequences = shortest_seq(r_sequences, dirpad, dirpad_map)
  end

  # r_sequences = [
  #   '<AAAv<A>>^Av<AAA^>A<Av>A^Av<A^>A',
  #   '<AAAv<A>>^Av<AAA^>A<Av>A^Av<A>^A',
  #   '<AAAv<A>>^Av<AAA^>A<Av>A^A<vA^>A',
  #   '<AAAv<A>>^Av<AAA^>A<Av>A^A<vA>^A',
  #   '<AAAv<A>>^Av<AAA^>A<A>vA^Av<A^>A',
  #   '<AAAv<A>>^Av<AAA^>A<A>vA^Av<A>^A',
  #   '<AAAv<A>>^Av<AAA^>A<A>vA^A<vA^>A',
  #   '<AAAv<A>>^Av<AAA^>A<A>vA^A<vA>^A',
  #   '<AAAv<A>>^Av<AAA>^A<Av>A^Av<A^>A',
  #   '<AAAv<A>>^Av<AAA>^A<Av>A^Av<A>^A',
  #   '<AAAv<A>>^Av<AAA>^A<Av>A^A<vA^>A',
  #   '<AAAv<A>>^Av<AAA>^A<Av>A^A<vA>^A',
  #   '<AAAv<A>>^Av<AAA>^A<A>vA^Av<A^>A',
  #   '<AAAv<A>>^Av<AAA>^A<A>vA^Av<A>^A',
  #   '<AAAv<A>>^Av<AAA>^A<A>vA^A<vA^>A',
  #   '<AAAv<A>>^Av<AAA>^A<A>vA^A<vA>^A',
  #   '<AAAv<A>>^A<vAAA^>A<Av>A^Av<A^>A',
  #   '<AAAv<A>>^A<vAAA^>A<Av>A^Av<A>^A',
  #   '<AAAv<A>>^A<vAAA^>A<Av>A^A<vA^>A',
  #   '<AAAv<A>>^A<vAAA^>A<Av>A^A<vA>^A',
  #   '<AAAv<A>>^A<vAAA^>A<A>vA^Av<A^>A',
  #   '<AAAv<A>>^A<vAAA^>A<A>vA^Av<A>^A',
  #   '<AAAv<A>>^A<vAAA^>A<A>vA^A<vA^>A',
  #   '<AAAv<A>>^A<vAAA^>A<A>vA^A<vA>^A',
  #   '<AAAv<A>>^A<vAAA>^A<Av>A^Av<A^>A',
  #   '<AAAv<A>>^A<vAAA>^A<Av>A^Av<A>^A',
  #   '<AAAv<A>>^A<vAAA>^A<Av>A^A<vA^>A',
  #   '<AAAv<A>>^A<vAAA>^A<Av>A^A<vA>^A',
  #   '<AAAv<A>>^A<vAAA>^A<A>vA^Av<A^>A',
  #   '<AAAv<A>>^A<vAAA>^A<A>vA^Av<A>^A',
  #   '<AAAv<A>>^A<vAAA>^A<A>vA^A<vA^>A',
  #   '<AAAv<A>>^A<vAAA>^A<A>vA^A<vA>^A'
  # ]
  # r_sequences = r_sequences.flat_map do |s|
  #   shortest_seq(s, dirpad, dirpad_map, dir_map)
  # end

  puts r_sequences.join

  min_ops = r_sequences.size
  num = code[0..code.size - 2].join.to_i

  sum += num * min_ops
  puts "#{num} * #{min_ops} = #{num * min_ops}"
end

puts sum
