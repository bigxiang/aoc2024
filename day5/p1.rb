f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
rules = []
manuals = []
is_rule_line = true
f.each_line do |line|
  if line == "\n"
    is_rule_line = false
  else
    rules << line.split('|').map(&:to_i) if is_rule_line
    manuals << line.split(',').map(&:to_i) unless is_rule_line
  end
end
# puts rules.size
# puts rules[0].size
# puts manuals.size
# puts manuals[0].size
rules_map = rules.each_with_object({}) do |(before, after), memo|
  memo[before] ||= Set.new
  memo[before].add(after)
end

valid_manuals = manuals.select do |manual|
  # next if j != 197

  manual_map = manual.each_with_object({}).with_index do |(num, memo), i|
    memo[num] = [i, false]
  end

  result = true

  while result && (first_page = manual.find { |page| !manual_map[page][1] })
    queue = []
    queue << first_page
    queue_i = 0

    # puts '===20'
    # puts queue.join(',')
    while result && queue_i < queue.size
      curr_page = queue[queue_i]
      queue_i += 1

      next if manual_map[curr_page][1]

      curr_index = manual_map[curr_page][0]
      manual_map[curr_page][1] = true

      # puts '===24'
      # puts curr_page
      # puts rules_map[curr_page].join(',')
      rules_map[curr_page].each do |page|
        next unless manual_map.key?(page)

        if manual_map[page][0] < curr_index
          result = false
          break
        end

        queue << page
      end
    end
    # puts '===30'
  end
  result
end

puts valid_manuals.size
puts(valid_manuals.map { |m| m[m.size / 2] }.sum)
