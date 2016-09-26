def main
  puts `bundle exec ruby ethereum.rb`
end

# parity, default settings
#
# 5 concurrent processes - get calls - get(1) -> returns [1, "hello", "world"]
#
# 7k req / sec - 8 cores - 20k req/sec theoretical max on a big server
#
#

ts = []
ts << Thread.new { main }
ts << Thread.new { main }
ts << Thread.new { main }
ts << Thread.new { main }
ts << Thread.new { main }

ts.each{ |t| t.join }

# bundle exec ruby tmp/bench.rb
