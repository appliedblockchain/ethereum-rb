require_relative '../ethereum'

ETH = Ethereum::Eth.new



describe "RPC Calls" do
  it "gets block height" do
    raise ETH.block_get.inspect
  end
end
