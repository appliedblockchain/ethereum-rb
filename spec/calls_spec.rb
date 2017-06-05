require_relative '../ethereum'

ETH = Ethereum::Eth.new

describe "RPC Calls" do
  it "gets block height" do
    ETH.block_get.should_not be_nil
    ETH.block_get.should be_a Integer
    ETH.block_get.should be >= 0
  end

  it "coinbase" do
    coinbase = ETH.coinbase
    coinbase[0..1].should == "0x"
    coinbase.size.should  == 42
  end

  it "gets balance" do
    scale = 10 ** 5
    balance = ETH.balance
    balance[0..1].should == "0x"
    # TODO: FIXME: return a numeric balance
  end

  specify "get (eth_call)" do
    # note: this spec requires deployed contracts
    ETH.get contract: :key_value, method: :get, params: ["foo"]
  end

  specify "set (eth_sendTransaction)" do


  end

end
