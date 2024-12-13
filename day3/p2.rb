f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = []
f.each_line do |line|
  lines << line
end

PATTERN = /mul\(\d{1,3},\d{1,3}\)|don't\(\)|do\(\)/

matches = lines.flat_map do |line|
  line.scan(PATTERN)
end

puts matches.size

total = 0
nums = []
while matches.size > 0
  match = matches.pop
  if match == "don't()"
    nums = []
  elsif match == 'do()'
    total += nums.reduce(0) { |sum, (num1, num2)| sum + num1 * num2 }
    nums = []
  else
    nums << match.scan(/\d{1,3}/).map(&:to_i)
  end
end

total += nums.reduce(0) { |sum, (num1, num2)| sum + num1 * num2 }
puts total
