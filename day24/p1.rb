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

WIRE_PATTERN = /([x|y]\d{2}): (\d)/
CALCULATION_PATTERN = /(\w+)\s(OR|AND|XOR)\s(\w+)\s->\s(\w+)/
lines.each do |line|
  next if line == "\n"

  if (wire_line = line.match(WIRE_PATTERN))
    wire, value = wire_line.captures
    wires[wire] = value.to_i
  end

  if (calculation_line = line.match(CALCULATION_PATTERN))
    left, operator, right, result = calculation_line.captures
    calculations[result] = [operator, left, right]
  end
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
  curr_result = queue[queue_i]
  queue_i += 1

  calculation = calculations[curr_result]
  value = gates[calculation[0]].call(wires[calculation[1]], wires[calculation[2]])

  wires[curr_result] = value

  out_edges.fetch(curr_result, []).each do |result|
    in_degrees[result] -= 1

    queue << result if in_degrees[result] == 0
  end
end

puts wires

num = 0
wires.select { |wire, _v| wire.start_with?('z') }.map { |wire, v| [wire, v] }.sort.each_with_index do |(_wire, v), i|
  num = v << i | num
end
puts num
