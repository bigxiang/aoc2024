# lines = [
#   "r, wr, b, g, bwu, rb, gb, br\n",
#   "\n",
#   "brwrr\n",
#   "bggr\n",
#   "gbbr\n",
#   "rrbgbr\n",
#   "ubwu\n",
#   "bwurrg\n",
#   "brgr\n",
#   "bbrgwb\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

patterns = Set.new
designs = []
lines.each_with_index do |line, i|
  if i == 0
    patterns.merge(line.chomp.split(', '))
  elsif line != "\n"
    designs << line.chomp
  end
end

puts "patterns: #{patterns}"
puts "designs: #{designs}"

max_pattern_size = patterns.map { |p| p.size }.max

def match(patterns, design, left, right, max_pattern_size)
  return false if right >= design.size
  return false unless patterns.include?(design[left..right])

  return true if right == design.size - 1

  (1..max_pattern_size).each do |i|
    result = match(patterns, design, right + 1, right + i, max_pattern_size)
    return true if result
  end

  false
end

indexes = designs.map.with_index do |design, i|
  result = false
  (0..max_pattern_size - 1).each do |i|
    result = match(patterns, design, 0, i, max_pattern_size)
    break if result
  end
  result && i
end.select(&:itself)

puts "indexes: #{indexes}"

available_designs =
  designs.select do |design|
    result = false
    (0..max_pattern_size - 1).each do |i|
      result = match(patterns, design, 0, i, max_pattern_size)
      break if result
    end
    result
  end

# puts "available_designs: #{available_designs}"
puts "size: #{available_designs.size}"
