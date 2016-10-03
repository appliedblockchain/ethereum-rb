# Formatting - spec

require_relative '../env'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = %i(should expect) }
end

# require_relative '../ethereum'

include Formatting



#
#
# get (input_params)
#   output_params #returned
#
#

# transform_input_params
#
# transform_params
#


# no-framework spec:

# params = []
# inputs = []
#
# out = transform_params params, inputs: inputs
# raise out.inspect


# ------------

describe "Types and Formatters - #transform_params" do
  it "hello worlds" do
    params = []
    inputs = []

    out = transform_params params, inputs: inputs
    out.should be_an Array
    out.should be_empty
  end

  it "hello worlds without errors" do
    params = []
    inputs = []

    expect {
      transform_params params, inputs: inputs
    }.to_not raise_error
  end

  it "hello worlds with an error on inputs being a wrong type" do
    params = []
    inputs = {} # hash instead of array

    expect {
      transform_params params, inputs: inputs
    }.to raise_error
    expect {
      transform_params params, inputs: inputs
    }.to raise_error(RuntimeError)
  end

  it "transform_params() basic - uint" do
    params = [1]
    inputs = [{ "type" => "uint" }]

    out = transform_params params, inputs: inputs
    out.should be_a Array
    out.should_not be_empty
    out.should == ["0000000000000000000000000000000000000000000000000000000000000001"]
  end

  it "transform_params() basic - bytes32" do
    params = ["a"]
    inputs = [{ "type" => "bytes32" }]

    out = transform_params params, inputs: inputs
    out.should be_a Array
    out.should_not be_empty
    out.should == ["6100000000000000000000000000000000000000000000000000000000000000"]
  end

  it "transform_params() basic - bytes32 (two params)" do
    params = ["a", "b"]
    inputs = [{ "type" => "bytes32" }, { "type" => "bytes32" }]

    out = transform_params params, inputs: inputs
    out.should be_a Array
    out.should_not be_empty
    out.should == ["6100000000000000000000000000000000000000000000000000000000000000", "6200000000000000000000000000000000000000000000000000000000000000"]
  end


  it "transform_params() basic - bytes" do
    params = ["a"]
    inputs = [{ "type" => "bytes" }]

    out = transform_params params, inputs: inputs
    out.should be_a Array
    out.should_not be_empty
    out.should == ["6100000000000000000000000000000000000000000000000000000000000000"]
  end
end




# out.should ==


# ---------------------------


# transform_output_params
#
# transform_outputs
#
#
# params  =
# outputs =
# transform_outputs params, outputs: outputs



# ------------

# notes & code from js implementation of parsing types


# parsing bytes<N> from ethereum-js - thanks axic for the js code - hopefully I will be able to make a neat full implementation like him - right now this is a bit half-a**ed
#
# size = parseTypeN(type)
# if ((size % 8) || (size < 8) || (size > 256)) {
#   throw new Error('Invalid uint<N> width: ' + size)
# }
#
# num = parseNumber(value)
# if (num.bitLength() > size) {
#   throw new Error('Supplied uint exceeds width: ' + size + ' vs ' + num.bitLength())
# }
#
# ret.push(num.toArrayLike(Buffer, 'be', size / 8))
