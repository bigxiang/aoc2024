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
# machines << machine_def.map do |row|
#   row.match(ROW_PATTERN).captures.map(&:to_i)
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
  token_used = []

  a_move, b_move, target = machine
  a_times = 0
  b_times = [target[0] / b_move[0], target[1] / b_move[1]].min
  while b_times > 0
    a_times = (target[0] - b_times * b_move[0]) / a_move[0]

    # puts "a_times: #{a_times}, b_times: #{b_times}, target: #{target}, a_move: #{a_move}, b_move: #{b_move}"

    if a_times * a_move[0] + b_times * b_move[0] == target[0] && a_times * a_move[1] + b_times * b_move[1] == target[1]
      token_used << a_times * 3 + b_times
    end

    b_times -= 1
  end

  token_used.min || 0
end

puts machines.map { |machine| token_used_to_get_prize(machine) }.sum
