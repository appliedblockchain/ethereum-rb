require_relative '../ethereum'

ETH = Ethereum::Eth.new



describe "RPC Calls" do
  xit "gets block height" do
    ETH.block_get.should == "123"
  end

  xit "coinbase" do
    coinbase = ETH.coinbase
    coinbase[0..1].should == "0x"
    # coinbase.size.should == 123
  end

  xit "gets balance" do
    # need to use it with a maximum balance otherwise the spec will fail
    scale = 10 ** 5
    balance = ETH.balance / scale
    balance.round.should == 1.6
  end


end
