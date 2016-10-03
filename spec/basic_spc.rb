# basic spec

require_relative 'spec_helper'


# simple and naive bash scripts test runner - no deps #pureRuby

# check spec_helper for implementation details, a very minimal spec helper

# API:

# expect output, :is, expected
# expect output, :=~, expected

# ---




# Actual specs follow:

# ---

# First spec:

#   check that everything runs w/o exceptions being rased (main library)

# put expected value/condition/action at the top cause usually it's longer than generating the output
# expected = "long match string"
expected = /status:OK/i

output = exec "#{ETH_PATH}/run"

# expect output, :is, expected
expect output, :=~, expected

#   check that everything runs w/o errs. (simplest example)

# ------------



# -----------

# Second spec (basic integration test of entries contract)

# example.rb (a better name would be entries test)

# TODO: create one entry with 'asdasd' name first if you want to do exact return value specs otherwise any entry is ok

# ETH.set contract: :simple_storage, method: :set, params: ["1", "asdasd"]
# ETH.set contract: :simple_storage, method: :set, params: [1, "asdasd"]

exp0 = /status:OK/i

exp1 = /entries count\:/ # count
# exp1 = /entries count:1/ # count # (w/ exact return value matching)

exp2 = /entry: {"_id"=>(\d+), "name"=>"(\w+)"}/ #
# exp2 = /entry: {\"_id\"=>1, \"name\"=>\"asdasd\"}/ #

exp3 = /set Entries\.update\((\d+), (\w+)\)/
# exp3 = /set Entries.update(1, asdasd)/

output = exec "ruby #{ETH_PATH}/tmp/basic_example.rb"

expectations = [exp0, exp1, exp2, exp3]
expectations.map do |expected|
  expect output, :=~, expected
end

puts
puts "ALL specs PASS!"
puts "rejoice!"
puts
