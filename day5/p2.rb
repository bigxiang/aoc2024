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

def valid?(manual, rules_map)
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

        result = false if manual_map[page][0] < curr_index

        queue << page
      end
    end
    # puts '===30'
  end
  result
end

invalid_manuals = manuals.select do |manual|
  !valid?(manual, rules_map)
end

deps_map = rules.each_with_object({}) do |(before, after), memo|
  memo[after] ||= Set.new
  memo[after].add(before)
end

fixed_manuals = invalid_manuals.map.with_index do |manual, i|
  # next if i != 0

  manual_set = Set.new(manual)

  manual_deps_map = manual.each_with_object({}) do |num, memo|
    memo[num] = deps_map.fetch(num, Set.new).intersection(manual_set)
  end

  in_degrees = manual.map do |num|
    manual_deps_map[num].size
  end

  result = []

  queue = manual.select.with_index { |_num, j| in_degrees[j] == 0 }
  queue_i = 0
  while queue_i < queue.size
    curr_page = queue[queue_i]
    queue_i += 1

    result << curr_page

    manual.each_with_index do |num, index|
      next unless manual_deps_map[num].include?(curr_page)

      manual_deps_map[num].delete(curr_page)
      in_degrees[index] -= 1

      queue << num if in_degrees[index] == 0
    end
    # puts '===10'
    # puts manual_deps_map
    # puts queue.join(',')
  end

  result
end

puts fixed_manuals.map { |manual| manual[manual.size / 2] }.sum
