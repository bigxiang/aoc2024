f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = []
f.each_line do |line|
  lines << line
end

PATTERN = /mul\(\d{1,3},\d{1,3}\)/

matches = lines.flat_map do |line|
  line.scan(PATTERN)
end

puts matches.size

nums = matches.map do |match|
  match.scan(/\d{1,3}/).map(&:to_i)
end

puts nums.size

puts nums.reduce(0) { |sum, (num1, num2)| sum + num1 * num2 }
