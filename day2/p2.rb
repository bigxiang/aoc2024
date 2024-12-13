f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
reports = []
f.each_line do |line|
  reports << line.split(/\s+/).map(&:to_i)
end

# puts reports.size
# puts reports[0].size
# puts reports[0]

def safe?(report, r, error_level = 0)
  direction = nil
  (1...report.size).each do |i|
    diff = report[i] - report[i - 1]
    new_direction = diff > 0 ? 1 : -1

    is_unsafe = direction && direction != new_direction || diff.abs < 1 || diff.abs > 3
    if is_unsafe
      return false if error_level == 1

      # return safe?([*report[0...i], *report[i + 1..]], r, 1) if diff.abs < 1 || diff.abs > 3

      return safe?([*report[0...i], *report[i + 1..]], r, 1) ||
             safe?([*report[0...i - 1], *report[i..]], r, 1) ||
             safe?([*report[0...i - 2], *report[i - 1..]], r, 1)

    end

    direction = new_direction
  end

  puts "#{r}:#{report.join(',')}"
  true
end

puts reports.map.with_index { |report, i| safe?(report, i) }.select(&:itself).size
