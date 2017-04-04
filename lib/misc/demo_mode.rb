# demo usage


ETH = Ethereum::Eth.new

ETH.start do |eth|
  val = eth.get contract: :op_return, method: :data, params: ['{ "message": "hello world" }']
  puts "Finished - got: #{val}"
end
