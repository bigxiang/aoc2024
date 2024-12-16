# lines = [
#   "Button A: X+94, Y+34\n",
#   "Button B: X+22, Y+67\n",
#   "Prize: X=8400, Y=5400\n",
#   "\n",
#   "Button A: X+26, Y+66\n",
#   "Button B: X+67, Y+21\n",
#   "Prize: X=12748, Y=12176\n",
#   "\n",
#   "Button A: X+17, Y+86\n",
#   "Button B: X+84, Y+37\n",
#   "Prize: X=7870, Y=6450\n",
#   "\n",
#   "Button A: X+69, Y+23\n",
#   "Button B: X+27, Y+71\n",
#   "Prize: X=18641, Y=10279\n"
# ]

ROW_PATTERN = /X[+|=](\d+),\s+Y[+|=](\d+)/
machine_def = []
machines = []
# lines.each do |line|
#   if line != "\n"
#     machine_def << line
#   else
#     machines << machine_def.map do |row|
#       row.match(ROW_PATTERN).captures.map(&:to_i)
#     end
#     machine_def = []
#   end
# end

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
f.each_line do |line|
  if line != "\n"
    machine_def << line
  else
    machines << machine_def.map do |row|
      row.match(ROW_PATTERN).captures.map(&:to_i)
    end
    machine_def = []
  end
end

machines << machine_def.map do |row|
  row.match(ROW_PATTERN).captures.map(&:to_i)
end
puts machines.map { |m| m.map { |p| p.join(',') }.join(' ') }.join("\n")

def token_used_to_get_prize(machine)
  token_used = 0

  a_move, b_move, target = machine
  target = [target[0] + 10_000_000_000_000, target[1] + 10_000_000_000_000]

  determinant = a_move[0] * b_move[1] - a_move[1] * b_move[0]
  return 0 if determinant == 0

  a_times = (target[0] * b_move[1] - target[1] * b_move[0]) / determinant.to_f
  b_times = (a_move[0] * target[1] - a_move[1] * target[0]) / determinant.to_f

  token_used = a_times * 3 + b_times if a_times == a_times.to_i && b_times == b_times.to_i
  token_used
end

machines.each { |m| puts token_used_to_get_prize(m) }

puts machines.map { |machine| token_used_to_get_prize(machine) }.sum
