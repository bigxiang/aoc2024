# lines = [
#   "123\n"
# ]

# lines = %W[
#   1\n
#   2\n
#   3\n
#   2024\n
# ]

f = File.open(File.join(File.dirname(__FILE__), '/input.txt'))
lines = f.readlines

secrets = []

lines.each do |line|
  secrets << line.chomp.to_i
end

def generate_secret(secret)
  value = secret << 6
  secret = mix(value, secret)
  secret = prune(secret)

  value = secret >> 5
  secret = mix(value, secret)
  secret = prune(secret)

  value = secret << 11
  secret = mix(value, secret)
  prune(secret)
end

def mix(value, secret)
  value ^ secret
end

def prune(secret)
  secret & (16_777_216 - 1)
end

def last_digit(num)
  num % 10
end

sum = 0
total_sells = {}
secrets.each do |secret|
  result = 0
  sequences = []
  curr_sells = {}

  2000.times do |i|
    result = generate_secret(secret)
    price = last_digit(result)
    prev_price = last_digit(secret)

    sequences.push(price - prev_price)

    # puts "sequence: #{sequences}, price: #{price}, prev_price: #{prev_price}, i: #{i}" if sequences == [-2, 1, -1, 3]
    curr_sequences = sequences[-4..]

    curr_sells[curr_sequences] = price if i >= 3 && !curr_sells.key?(curr_sequences)

    secret = result
  end
  # puts result
  sum += result
  total_sells.keys.each do |sequence|
    total_sells[sequence] += curr_sells.fetch(sequence, 0)
  end

  curr_sells.keys.each do |sequence|
    total_sells[sequence] = curr_sells[sequence] unless total_sells.key?(sequence)
  end
end

puts sum
puts total_sells.values.max
# puts total_sells
