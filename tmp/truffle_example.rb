path_out = File.expand_path "../../../", __FILE__
ENV["CONFIG_DIR"] = "#{path_out}/cygnetise_contracts/build"
ENV["CONTRACT_ADDRESS"] = "0xa821405c2ac2afd5277e3a4cc3ee64dacb60bc9f"
ENV["CONTRACT_NAME"] = "Cygnetise"
require_relative '../ethereum'
ETH = Ethereum::Eth.new
ETH.init
# ETH....

# ETH.get contract: :cygnetise, method: :getter_aka_call, params: [id]
#
# ETH.set contract: :cygnetise, method: :setter_aka_sendtransaction, params: attrs.values


class Helper
  # TODO: check if that stuff already exists somewhere
  def self.to_hex(data)
    data.each_byte.map { |b| b.to_s(16) }.join
  end

  def self.to_bin(data)
    data.scan(/../).map { |x| x.hex.chr }.join
  end

  def self.clean(data)
    if data[0] == '0' && data[1] == 'x'
      data[2..-1]
    else
      data
    end
  end
end

class User
  # TODO: write automated tests in rspec
  def self.count()
    ETH.get contract: :cygnetise, method: :usersCount, params: []
  end

  def self.get(id:)
    ETH.get contract: :cygnetise, method: :getUser, params: [id]
  end

  def self.get_full(id:)
    # TODO: add multi return support
    ETH.get contract: :cygnetise, method: :getUserFull, params: [id]
  end

  def self.create(value:, hash:, sig:, address:)
    # example args
    # value: hello
    # hash: 0x1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8
    # sig: 0xde4fff3c6895f6f6e6342e327a9c09aa41fc9acd176a73f931b0b25f04e2b72261e99714f624547eaac24a3235cd7a8f051991c156cc03420eb4810544d1ffda00
    # address: 0x11587d900c62749fdcd4434a1b7ae7651ccb3af3
    hash = Helper.clean hash
    sig = Helper.clean sig
    hash = Helper.to_bin hash
    sig = Helper.to_bin sig
    ETH.set contract: :cygnetise, method: :createUser, params: [value, hash, sig, address]
  end

  def self.update(id:, value:, hash:, sig:, address:)
    # value: hello vlad wulf
    # hash: 0xd618b8165defcb0775e8d059e93415a5ee57fab4cbb6177edba5991b9ada9c34
    # sig: 0x0010f5191cd66ed6338b78b987f61c03f7d24ed45f1ad6a01aa26c49e430ab805114d43214353f309bd806bbb327bdab94ee4c1200f9d5236b9ffb98a60ca6d001
    # address: 0x11587d900c62749fdcd4434a1b7ae7651ccb3af3
    hash = Helper.clean hash
    sig = Helper.clean sig
    hash = Helper.to_bin hash
    sig = Helper.to_bin sig
    ETH.set contract: :cygnetise, method: :updateUser, params: [id, value, hash, sig, address]
  end
end

