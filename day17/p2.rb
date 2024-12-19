# lines = [
#   "Register A: 0\n",
#   "Register B: 0\n",
#   "Register C: 0\n",
#   "\n",
#   "Program: 0,3,5,4,3,0\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

regs = [0, 0, 0]
program = []
lines.each do |line|
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
  # puts "before adv: operand: #{operand}, regs: #{regs}"
  denominator = 2.pow(combo_operand(operand, regs))
  regs[0] /= denominator
  # puts "after adv: operand: #{operand}, regs: #{regs}"

  i + 2
end

def bxl(regs, operand, i)
  # puts "before bxl: operand: #{operand}, regs: #{regs}"
  regs[1] ^= operand
  # puts "after bxl: operand: #{operand}, regs: #{regs}"

  i + 2
end

def bst(regs, operand, i)
  # puts "before bst: operand: #{operand}, regs: #{regs}"
  regs[1] = combo_operand(operand, regs) % 8
  # puts "after bst: operand: #{operand}, regs: #{regs}"

  i + 2
end

def jnz(regs, operand, i)
  i + 2
end

def bxc(regs, _operand, i)
  # puts "before bxc: operand: #{_operand}, regs: #{regs}"
  regs[1] ^= regs[2]
  # puts "after bxc: operand: #{_operand}, regs: #{regs}"

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
  # puts "before cdv: operand: #{operand}, regs: #{regs}"
  denominator = 2.pow(combo_operand(operand, regs))
  regs[2] = regs[0] / denominator
  # puts "after cdv: operand: #{operand}, regs: #{regs}"

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

i = program.size - 1
buffer = []
init_reg_as = [0]
while i >= 0
  new_reg_as = []
  init_reg_as.each do |init_reg_a|
    (init_reg_a..init_reg_a + 7).each do |reg_a|
      regs[0] = reg_a

      program_i = 0
      while program_i < program.size
        opcode = program[program_i]
        operation = operations[opcode]
        operand = program[program_i + 1]

        program_i = operation.call(regs, operand, program_i, buffer)
      end
      if buffer[0] == program[i]
        puts "found match for i: #{i}, reg_a: #{reg_a}"
        new_reg_as << (reg_a << 3)
      else
        # puts "no match for i: #{i}, reg_a: #{reg_a}, regs: #{regs}, buffer: #{buffer}"
      end
      buffer = []
    end
  end

  init_reg_as = new_reg_as
  puts "init_reg_as: #{init_reg_as}"
  i -= 1
end

# puts "regs: #{regs}"
