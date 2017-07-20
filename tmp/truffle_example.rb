path_out = File.expand_path "../../../", __FILE__
ENV["CONFIG_DIR"] = "#{path_out}/cygnetise_contracts/build"
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

user = User.get id: 1
puts "USER: #{user.inspect}"
