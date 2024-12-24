# lines = %W[
#   kh-tc\n
#   qp-kh\n
#   de-cg\n
#   ka-co\n
#   yn-aq\n
#   qp-ub\n
#   cg-tb\n
#   vc-aq\n
#   tb-ka\n
#   wh-tc\n
#   yn-cg\n
#   kh-ub\n
#   ta-co\n
#   de-co\n
#   tc-td\n
#   tb-wq\n
#   wh-td\n
#   ta-ka\n
#   td-qp\n
#   aq-cg\n
#   wq-ub\n
#   ub-vc\n
#   de-ta\n
#   wq-aq\n
#   wq-vc\n
#   wh-yn\n
#   ka-de\n
#   kh-ta\n
#   co-tc\n
#   wh-qp\n
#   tb-vc\n
#   td-yn\n
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

connections = []
machines_set = Set.new
machines = []
machines_map = {}
lines.each do |line|
  m1, m2 = line.chomp.split('-')
  connections << [m1, m2]

  machines_set.add(m1)
  machines_set.add(m2)
end

machines = machines_set.to_a.sort
machines_map = machines.map.with_index { |m, i| [m, i] }.to_h

puts machines_map

t_machines_start = machines.bsearch_index { |m| m[0] >= 't' }
t_machines_end = machines.bsearch_index { |m| m[0] >= 'u' }

puts machines[t_machines_start...t_machines_end].join(',')

adj = Array.new(machines.size) { Array.new(machines.size, 0) }
adj.each_with_index do |row, i|
  row.each_with_index do |col, j|
    adj[i][j] = 1 if i == j
  end
end

connections.each do |(m1, m2)|
  i = machines_map[m1]
  j = machines_map[m2]

  adj[i][j] = 1
  adj[j][i] = 1
end

puts adj.map { |r| r.join }.join("\n")

triangles = []
(0...t_machines_start).each do |i|
  (i + 1...t_machines_start).each do |j|
    (t_machines_start...t_machines_end).each do |k|
      # (j + 1...machines.size).each do |k|
      triangles << [machines[i], machines[j], machines[k]] if adj[i][j] == 1 && adj[i][k] == 1 && adj[j][k] == 1
    end
  end

  (t_machines_start...t_machines_end).each do |j|
    (j + 1...machines.size).each do |k|
      triangles << [machines[i], machines[j], machines[k]] if adj[i][j] == 1 && adj[i][k] == 1 && adj[j][k] == 1
    end
  end
end

(t_machines_start...t_machines_end).each do |i|
  (i + 1...machines.size).each do |j|
    (j + 1...machines.size).each do |k|
      triangles << [machines[i], machines[j], machines[k]] if adj[i][j] == 1 && adj[i][k] == 1 && adj[j][k] == 1
    end
  end
end

# puts triangles.map { |r| r.join(',') }.join("\n")
puts triangles.size
