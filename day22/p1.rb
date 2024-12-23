# lines = [
#   "123\n"
# ]

# lines = %W[
#   1\n
#   10\n
#   100\n
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

sum = 0
secrets.each do |secret|
  result = 0
  2000.times do
    result = generate_secret(secret)
    secret = result
  end
  # puts result
  sum += result
end

puts sum
