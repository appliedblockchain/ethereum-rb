Thread.abort_on_exception = true

puts Time.now
sleep 1

5.times do
Thread.new do
  puts `time ./run`
  puts Time.now
end
end



sleep 6
sleep 200
puts "done!"
