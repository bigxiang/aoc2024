f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
reports = []
f.each_line do |line|
  reports << line.split(/\s+/).map(&:to_i)
end

# puts reports.size
# puts reports[0].size
# puts reports[0]

def safe?(report)
  direction = nil
  (1...report.size).each do |i|
    diff = report[i] - report[i - 1]
    new_direction = diff > 0 ? 1 : -1

    return false if direction && direction != new_direction || diff.abs < 1 || diff.abs > 3

    direction = new_direction
  end
  true
end

puts reports.map { |report| safe?(report) }.select(&:itself).size
