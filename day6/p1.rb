f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
matrix = []
f.each_line do |line|
  matrix << line.strip.split('')
end

puts matrix.size
puts matrix[0].size

count = 0
(0...matrix.size).each do |i|
  (0...matrix[i].size).each do |j|
    next if matrix[i][j] != '^'

    m = i
    n = j
    dm = -1
    dn = 0

    while m >= 0 && n >= 0 && m < matrix.size && n < matrix[m].size
      if matrix[m][n] == '#'
        m -= dm
        n -= dn

        dm, dn = dn, -dm
        m += dm
        n += dn
        next
      end

      if matrix[m][n] != 'X'
        count += 1
        matrix[m][n] = 'X'
      end

      m += dm
      n += dn
    end
  end
end

puts count
