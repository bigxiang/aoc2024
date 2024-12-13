# disk_map = '2333133121414131402'
# disk_map = '1771316180312550163633387627715459675444'

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
disk_map = f.gets.strip

# puts disk_map

file_id = 0
blocks = []
free_spaces = {}
files = {}
disk_map.chars.each_with_index do |num_str, i|
  num = num_str.to_i
  if i.even?
    files[file_id] = [blocks.size, num]
    num.times { blocks << file_id }
    file_id += 1
  elsif num > 0
    free_spaces[num] ||= []
    free_spaces[num] << blocks.size
    num.times { blocks << '.' }
  end
end

puts blocks.select { |b| b == '.' }.size
# puts blocks.size
# puts blocks.join(',')
# puts free_spaces.map { |e| e.join(' ') }.join(',')

# puts(free_spaces.bsearch_index { |free_space| free_space[0] >= 3 })
# puts blocks == '00...111...2...333.44.5555.6666.777.888899'

files.keys.sort.reverse.each do |fid|
  file_index, file_size = files[fid]
  # puts '==='
  # puts "#{fid}, #{file_index}, #{file_size}"
  # puts free_spaces

  first_available_free_space =
    free_spaces
    .select { |free_space_size, _v| free_space_size >= file_size }
    .map { |free_space_size, free_space_indexes| [free_space_size, free_space_indexes[0]] }
    .min { |a, b| a[1] <=> b[1] }

  next if first_available_free_space.nil?

  free_space_size, free_space_index = first_available_free_space
  # puts "free_space: #{free_space_index}, #{free_space_size}"
  next if free_space_index >= file_index

  blocks[free_space_index, file_size] = Array.new(file_size, fid)
  blocks[file_index, file_size] = Array.new(file_size, '.')

  # puts blocks.join(',')

  # files[fid] = [free_space_index, file_size]
  free_spaces[free_space_size].shift
  free_spaces.delete(free_space_size) if free_spaces[free_space_size].empty?

  next unless (new_free_space_size = free_space_size - file_size) > 0

  free_spaces[new_free_space_size] ||= []
  free_spaces[new_free_space_size] << (free_space_index + file_size)
  free_spaces[new_free_space_size].sort!
end

puts blocks.select { |b| b == '.' }.size
puts free_spaces.keys.join(',')
# puts blocks.join(',')
# # puts blocks.join('') == '00992111777.44.333....5555.6666.....8888..'

checksum = 0
blocks.each_with_index do |fid, i|
  next if fid == '.'

  checksum += i * fid
end

puts checksum
