lines = %W[
  kh-tc\n
  qp-kh\n
  de-cg\n
  ka-co\n
  yn-aq\n
  qp-ub\n
  cg-tb\n
  vc-aq\n
  tb-ka\n
  wh-tc\n
  yn-cg\n
  kh-ub\n
  ta-co\n
  de-co\n
  tc-td\n
  tb-wq\n
  wh-td\n
  ta-ka\n
  td-qp\n
  aq-cg\n
  wq-ub\n
  ub-vc\n
  de-ta\n
  wq-aq\n
  wq-vc\n
  wh-yn\n
  ka-de\n
  kh-ta\n
  co-tc\n
  wh-qp\n
  tb-vc\n
  td-yn\n
]

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

def add_to_party(adj, i, party, l_parties)
  if i >= adj.size
    l_parties << party if party.size >= (l_parties.map(&:size).max || 0)
    return
  end

  if party.empty?
    party << i
  elsif party.all? { |m| adj[m][i] == 1 }
    add_to_party(adj, i + 1, party + [i], l_parties)
  end
  add_to_party(adj, i + 1, party.dup, l_parties)
end

l_parties = []
(0...adj.size).each do |i|
  add_to_party(adj, i, [], l_parties)
end

puts l_parties.map { |p| p.map { |m| machines[m] }.join(',') }.join("\n")
