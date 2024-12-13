f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
equations = []
f.each_line do |line|
  result, nums = line.split(':')
  result = result.to_i
  nums = nums.strip.split(' ').map(&:to_i)

  equations << [result, nums]
end

# puts equations.size
# puts equations[0]
# puts equations[1].size

def dfs(nums, i, operator, curr, result)
  return curr == result if i == nums.size

  if operator == '+'
    dfs(nums, i + 1, '+', curr + nums[i], result) ||
      dfs(nums, i + 1, '*', curr + nums[i], result) ||
      dfs(nums, i + 1, '||', curr + nums[i], result)
  elsif operator == '*'
    dfs(nums, i + 1, '+', curr * nums[i], result) ||
      dfs(nums, i + 1, '*', curr * nums[i], result) ||
      dfs(nums, i + 1, '||', curr * nums[i], result)
  else
    new_curr = "#{curr}#{nums[i]}".to_i
    dfs(nums, i + 1, '+', new_curr, result) ||
      dfs(nums, i + 1, '*', new_curr, result) ||
      dfs(nums, i + 1, '||', new_curr, result)
  end
end
sum = 0
equations.each do |(result, nums)|
  next unless dfs(nums, 1, '+', nums[0], result) ||
              dfs(nums, 1, '*', nums[0], result) ||
              dfs(nums, 1, '||', nums[0], result)

  sum += result
end

puts sum
