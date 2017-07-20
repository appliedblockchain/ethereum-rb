path_out = File.expand_path "../../../", __FILE__
ENV["CONFIG_DIR"] = "#{path_out}/cygnetise_contracts/build"
ENV["CONTRACT_ADDRESS"] = "0xaa93eacd11ea89a1b18ba40baa83e0184c08b906"
ENV["CONTRACT_NAME"] = "Cygnetise"
require_relative '../ethereum'
ETH = Ethereum::Eth.new
ETH.init
# ETH....

# ETH.get contract: :cygnetise, method: :getter_aka_call, params: [id]
#
# ETH.set contract: :cygnetise, method: :setter_aka_sendtransaction, params: attrs.values

class User
  def self.count()
    ETH.get contract: :cygnetise, method: :usersCount, params: []
  end

  def self.get(id:)
    ETH.get contract: :cygnetise, method: :getUser, params: [id]
  end
end

count = User.count
puts "USER count: #{count}"

# user = User.get id: 1
# puts "USER #1: #{user.inspect}"
