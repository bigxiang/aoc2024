# disk_map = '2333133121414131402'

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
disk_map = f.gets.strip

# puts disk_map

file_id = 0
blocks = []
disk_map.chars.each_with_index do |num_str, i|
  num = num_str.to_i
  if i.even?
    num.times { blocks << file_id }
    file_id += 1
  elsif num > 0
    num.times { blocks << '.' }
  end
end

puts blocks.size
# puts blocks.join('')
# puts blocks == '00...111...2...333.44.5555.6666.777.888899'

left = 0
right = blocks.size - 1
while left < right
  if blocks[left] == '.' && blocks[right] != '.'
    blocks[left] = blocks[right]
    blocks[right] = '.'
    left += 1
    right -= 1
  elsif blocks[left] != '.'
    left += 1
  else
    right -= 1
  end
end

# puts blocks.first(1000)
# puts blocks == '0099811188827773336446555566..............'

checksum = 0
blocks.each_with_index do |ele, i|
  break if ele == '.'

  checksum += i * ele
end

puts checksum
