# lines = [
#   "Register A: 729\n",
#   "Register B: 0\n",
#   "Register C: 0\n",
#   "\n",
#   "Program: 0,1,5,4,3,0\n"
# ]

# lines = [
#   "Register A: 0\n",
#   "Register B: 0\n",
#   "Register C: 9\n",
#   "\n",
#   "Program: 2,6\n"
# ]

# lines = [
#   "Register A: 10\n",
#   "Register B: 0\n",
#   "Register C: 0\n",
#   "\n",
#   "Program: 5,0,5,1,5,4\n"
# ]

# lines = [
#   "Register A: 2024\n",
#   "Register B: 0\n",
#   "Register C: 0\n",
#   "\n",
#   "Program: 0,3,5,4,3,0\n"
# ]

# lines = [
#   "Register A: 0\n",
#   "Register B: 29\n",
#   "Register C: 0\n",
#   "\n",
#   "Program: 1,7\n"
# ]

# lines = [
#   "Register A: 0\n",
#   "Register B: 2024\n",
#   "Register C: 43690\n",
#   "\n",
#   "Program: 4,0\n"
# ]

lines = [
  "Register A: 202975183645226\n",
  "Register B: 0\n",
  "Register C: 0\n",
  "\n",
  "Program: 2,4,1,1,7,5,0,3,1,4,4,4,5,5,3,0\n"
]

# f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
# lines = f.readlines

regs = []
program = []
lines.each do |line|
  regs[0] = line.match(/Register A: (\d+)/).captures[0].to_i if line.start_with?('Register A')
  regs[1] = line.match(/Register B: (\d+)/).captures[0].to_i if line.start_with?('Register B')
  regs[2] = line.match(/Register C: (\d+)/).captures[0].to_i if line.start_with?('Register C')

  program = line.match(/Program: (.*)/).captures[0].split(',').map(&:to_i) if line.start_with?('Program:')
end

puts "regs: #{regs}"
puts "program: #{program}"

def combo_operand(operand, regs)
  case operand
  when 0..3
    operand
  when 4..6
    regs[operand - 4]
  else
    raise "invalid operand: #{operand}"
  end
end

def adv(regs, operand, i)
  puts "adv: operand: #{operand}, regs: #{regs}"
  denominator = 2.pow(combo_operand(operand, regs))
  regs[0] /= denominator

  i + 2
end

def bxl(regs, operand, i)
  regs[1] ^= operand

  i + 2
end

def bst(regs, operand, i)
  regs[1] = combo_operand(operand, regs) % 8

  i + 2
end

def jnz(regs, operand, i)
  return i + 2 if regs[0] == 0

  operand
end

def bxc(regs, _operand, i)
  regs[1] ^= regs[2]

  i + 2
end

def out(regs, operand, i, buffer)
  buffer << (combo_operand(operand, regs) % 8)

  i + 2
end

def bdv(regs, operand, i)
  denominator = 2.pow(combo_operand(operand, regs))
  regs[1] = regs[0] / denominator

  i + 2
end

def cdv(regs, operand, i)
  denominator = 2.pow(combo_operand(operand, regs))
  regs[2] = regs[0] / denominator

  i + 2
end

operations = {
  0 => ->(regs, operand, i, buffer) { adv(regs, operand, i) },
  1 => ->(regs, operand, i, buffer) { bxl(regs, operand, i) },
  2 => ->(regs, operand, i, buffer) { bst(regs, operand, i) },
  3 => ->(regs, operand, i, buffer) { jnz(regs, operand, i) },
  4 => ->(regs, operand, i, buffer) { bxc(regs, operand, i) },
  5 => ->(regs, operand, i, buffer) { out(regs, operand, i, buffer) },
  6 => ->(regs, operand, i, buffer) { bdv(regs, operand, i) },
  7 => ->(regs, operand, i, buffer) { cdv(regs, operand, i) }
}

i = 0
buffer = []
while i < program.size
  opcode = program[i]
  operation = operations[opcode]
  operand = program[i + 1]

  i = operation.call(regs, operand, i, buffer)

  puts "i: #{i}, operation: #{opcode}, operand: #{operand}, regs: #{regs}, buffer: #{buffer}"
end

puts buffer.join(',')

# i: 14, operation: 5, operand: 5, regs: [5, 3, 0], buffer: [5, 5, 3]
# i: 0, operation: 3, operand: 0, regs: [5, 3, 0], buffer: [5, 5, 3]
# i: 2, operation: 2, operand: 4, regs: [5, 5, 0], buffer: [5, 5, 3]
# i: 4, operation: 1, operand: 1, regs: [5, 4, 0], buffer: [5, 5, 3]
# i: 6, operation: 7, operand: 5, regs: [5, 4, 0], buffer: [5, 5, 3]
# adv: operand: 3, regs: [5, 4, 0]
# i: 8, operation: 0, operand: 3, regs: [0, 4, 0], buffer: [5, 5, 3]
# i: 10, operation: 1, operand: 4, regs: [0, 0, 0], buffer: [5, 5, 3]
# i: 12, operation: 4, operand: 4, regs: [0, 0, 0], buffer: [5, 5, 3]
# i: 14, operation: 5, operand: 5, regs: [0, 0, 0], buffer: [5, 5, 3, 0]
# i: 16, operation: 3, operand: 0, regs: [0, 0, 0], buffer: [5, 5, 3, 0]
