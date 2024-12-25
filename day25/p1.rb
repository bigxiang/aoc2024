# lines = [
#   "#####\n",
#   ".####\n",
#   ".####\n",
#   ".####\n",
#   ".#.#.\n",
#   ".#...\n",
#   ".....\n",
#   "\n",
#   "#####\n",
#   "##.##\n",
#   ".#.##\n",
#   "...##\n",
#   "...#.\n",
#   "...#.\n",
#   ".....\n",
#   "\n",
#   ".....\n",
#   "#....\n",
#   "#....\n",
#   "#...#\n",
#   "#.#.#\n",
#   "#.###\n",
#   "#####\n",
#   "\n",
#   ".....\n",
#   ".....\n",
#   "#.#..\n",
#   "###..\n",
#   "###.#\n",
#   "###.#\n",
#   "#####\n",
#   "\n",
#   ".....\n",
#   ".....\n",
#   ".....\n",
#   "#....\n",
#   "#.#..\n",
#   "#.#.#\n",
#   "#####\n",
#   "\n"
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

locks = []
keys = []
schematics = []
lines.each do |line|
  if line == "\n"
    if schematics[0][0] == '#'
      locks << schematics
    else
      keys << schematics
    end

    schematics = []
  else
    schematics << line.chomp.chars
  end
end

unless schematics.empty?
  if schematics[0][0] == '#'
    locks << schematics
  else
    keys << schematics
  end
end

puts locks.map { |l| l.map { |r| r.join }.join("\n") }.join("\n\n")
puts ''
puts keys.map { |l| l.map { |r| r.join }.join("\n") }.join("\n\n")

locks = locks.map do |lock|
  result = []
  (0...lock[0].size).each do |j|
    (1...lock.size).each do |i|
      next if lock[i][j] == '#'

      result << i - 1
      break
    end
  end
  result
end

keys = keys.map do |key|
  result = []
  (0...key[0].size).each do |j|
    (key.size - 2).downto(0).each do |i|
      next if key[i][j] == '#'

      result << key.size - 2 - i
      break
    end
  end
  result
end

puts locks.map { |l| l.join(',') }.join("\n")
puts ''
puts keys.map { |l| l.join(',') }.join("\n")

count = 0
locks.each do |lock|
  keys.each do |key|
    match = true
    (0...lock.size).each do |i|
      next if lock[i] + key[i] <= 5

      match = false
      break
    end
    count += 1 if match
  end
end

puts count
