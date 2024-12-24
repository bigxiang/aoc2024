# lines = [
#   "x00: 1\n",
#   "x01: 0\n",
#   "x02: 1\n",
#   "x03: 1\n",
#   "x04: 0\n",
#   "y00: 1\n",
#   "y01: 1\n",
#   "y02: 1\n",
#   "y03: 1\n",
#   "y04: 1\n",
#   "\n",
#   "ntg XOR fgs -> mjb\n",
#   "y02 OR x01 -> tnw\n",
#   "kwq OR kpj -> z05\n",
#   "x00 OR x03 -> fst\n",
#   "tgd XOR rvg -> z01\n",
#   "vdt OR tnw -> bfw\n",
#   "bfw AND frj -> z10\n",
#   "ffh OR nrd -> bqk\n",
#   "y00 AND y03 -> djm\n",
#   "y03 OR y00 -> psh\n",
#   "bqk OR frj -> z08\n",
#   "tnw OR fst -> frj\n",
#   "gnj AND tgd -> z11\n",
#   "bfw XOR mjb -> z00\n",
#   "x03 OR x00 -> vdt\n",
#   "gnj AND wpb -> z02\n",
#   "x04 AND y00 -> kjc\n",
#   "djm OR pbm -> qhw\n",
#   "nrd AND vdt -> hwm\n",
#   "kjc AND fst -> rvg\n",
#   "y04 OR y02 -> fgs\n",
#   "y01 AND x02 -> pbm\n",
#   "ntg OR kjc -> kwq\n",
#   "psh XOR fgs -> tgd\n",
#   "qhw XOR tgd -> z09\n",
#   "pbm OR djm -> kpj\n",
#   "x03 XOR y03 -> ffh\n",
#   "x00 XOR y04 -> ntg\n",
#   "bfw OR bqk -> z06\n",
#   "nrd XOR fgs -> wpb\n",
#   "frj XOR qhw -> z04\n",
#   "bqk OR frj -> z07\n",
#   "y03 OR x01 -> nrd\n",
#   "hwm AND bqk -> z03\n",
#   "tgd XOR rvg -> z12\n",
#   "tnw OR pbm -> gnj\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

wires = {}
calculations = {}
calculations2 = {}

WIRE_PATTERN = /([x|y]\d{2}): (\d)/
CALCULATION_PATTERN = /(\w+)\s(OR|AND|XOR)\s(\w+)\s->\s(\w+)/
lines.each do |line|
  next if line == "\n"

  if (wire_line = line.match(WIRE_PATTERN))
    wire, value = wire_line.captures
    wires[wire] = value.to_i
  end

  next unless (calculation_line = line.match(CALCULATION_PATTERN))

  left, operator, right, result = calculation_line.captures
  calculations[result] = [operator, left, right]

  calculations2[[left, operator, right]] = result
end

puts wires
puts calculations

gates = {
  'AND' => ->(left, right) { left & right },
  'OR' => ->(left, right) { left | right },
  'XOR' => ->(left, right) { left ^ right }
}

in_degrees = {}
out_edges = {}
calculations.each do |result, (operator, left, right)|
  in_degree = 0
  in_degree += 1 unless wires.key?(left)
  in_degree += 1 unless wires.key?(right)

  in_degrees[result] = in_degree

  out_edges[left] ||= Set.new
  out_edges[left].add(result)

  out_edges[right] ||= Set.new
  out_edges[right].add(result)
end

puts in_degrees

queue = in_degrees.select { |_result, in_degree| in_degree == 0 }.keys
queue_i = 0

puts queue.join(',')

while queue_i < queue.size
  curr_bit = queue[queue_i]
  queue_i += 1

  calculation = calculations[curr_bit]
  value = gates[calculation[0]].call(wires[calculation[1]], wires[calculation[2]])

  wires[curr_bit] = value

  out_edges.fetch(curr_bit, []).each do |result|
    in_degrees[result] -= 1

    queue << result if in_degrees[result] == 0
  end
end

puts(wires.select { |wire, _v| wire.start_with?('x') }.to_a.sort.reverse.map { |_wire, v| v }.join.rjust(46, '0'))
puts(wires.select { |wire, _v| wire.start_with?('y') }.to_a.sort.reverse.map { |_wire, v| v }.join.rjust(46, '0'))
puts(wires.select { |wire, _v| wire.start_with?('z') }.to_a.sort.reverse.map { |_wire, v| v }.join)

x = 0
wires.select { |wire, _v| wire.start_with?('x') }.map { |wire, v| [wire, v] }.sort.each_with_index do |(_wire, v), i|
  x = v << i | x
end

y = 0
wires.select { |wire, _v| wire.start_with?('y') }.map { |wire, v| [wire, v] }.sort.each_with_index do |(_wire, v), i|
  y = v << i | y
end

z = 0
wires.select { |wire, _v| wire.start_with?('z') }.map { |wire, v| [wire, v] }.sort.each_with_index do |(_wire, v), i|
  z = v << i | z
end

diff_bits = (x + y ^ z).to_s(2).rjust(46, '0')
puts diff_bits
rev = diff_bits.reverse
rev.each_char.with_index do |bit, i|
  puts i if (i == 0 && bit == '1') || (bit == '1' && rev[i - 1] == '0')
end

prev_carry = ''
next_carry = ''
incorrect_wires = []
(0..44).each do |i|
  if i == 0
    x = 'x00'
    y = 'y00'

    curr_bit = calculations2[[x, 'XOR', y]] || calculations2[[y, 'XOR', x]]
    next_carry = calculations2[[x, 'AND', y]] || calculations2[[y, 'AND', x]]
    puts "#{x} XOR #{y} -> #{curr_bit}"
    puts "#{x} AND #{y} -> #{next_carry}"
  else
    x = "x#{i.to_s.rjust(2, '0')}"
    y = "y#{i.to_s.rjust(2, '0')}"
    invalid = {}

    curr_temp_bit = calculations2[[x, 'XOR', y]] || calculations2[[y, 'XOR', x]]
    invalid['curr_temp_bit'] = curr_temp_bit if curr_temp_bit.nil? || curr_temp_bit.start_with?('z')

    curr_temp_carry1 = calculations2[[x, 'AND', y]] || calculations2[[y, 'AND', x]]
    invalid['curr_temp_carry1'] = curr_temp_carry1 if curr_temp_carry1.nil? || curr_temp_carry1.start_with?('z')

    curr_bit = calculations2[[curr_temp_bit, 'XOR', prev_carry]] || calculations2[[prev_carry, 'XOR', curr_temp_bit]]
    if curr_bit.nil?
      puts "i: #{i}, reversed curr_bit: #{curr_temp_bit}, curr_temp_carry1: #{curr_temp_carry1}"
      curr_temp_bit, curr_temp_carry1 = curr_temp_carry1, curr_temp_bit
      curr_bit = calculations2[[curr_temp_bit, 'XOR', prev_carry]] || calculations2[[prev_carry, 'XOR', curr_temp_bit]]
      incorrect_wires << curr_temp_bit
      incorrect_wires << curr_temp_carry1
    elsif !curr_bit.start_with?('z')
      invalid['curr_bit'] = curr_bit

      if invalid.size == 2
        puts "i: #{i}, #{invalid}"
        values = invalid.values
        keys = invalid.keys.reverse
        keys.each_with_index do |key, i|
          incorrect_wires << values[i]
          eval("#{key}='#{values[i]}'")
        end
        invalid = {}
      end
    end

    curr_temp_carry2 = calculations2[[curr_temp_bit, 'AND',
                                      prev_carry]] || calculations2[[prev_carry, 'AND', curr_temp_bit]]
    invalid['curr_temp_carry2'] = curr_temp_carry2 if curr_temp_carry2.nil? || curr_temp_carry2.start_with?('z')

    if invalid.size == 2
      puts "i: #{i}, #{invalid}"
      values = invalid.values
      keys = invalid.keys.reverse
      keys.each_with_index do |key, i|
        incorrect_wires << values[i]
        eval("#{key}='#{values[i]}'")
      end
      invalid = {}
    end

    next_carry = calculations2[[curr_temp_carry1, 'OR',
                                curr_temp_carry2]] || calculations2[[curr_temp_carry2, 'OR', curr_temp_carry1]]
    invalid['next_carry'] = next_carry if next_carry.nil? || next_carry.start_with?('z')

    if invalid.size == 2
      puts "i: #{i}, #{invalid}"
      values = invalid.values
      keys = invalid.keys.reverse
      keys.each_with_index do |key, i|
        incorrect_wires << values[i]
        eval("#{key}='#{values[i]}'")
      end
      invalid = {}
    end
  end

  prev_carry = next_carry
end

puts incorrect_wires.sort.join(',')
