require_relative '../ethereum'

ETH = Ethereum::Eth.new

ETH.start do |eth|
  val = eth.get contract: :op_return, method: :data, params: []
  puts "Finished - got: #{val}"
end
