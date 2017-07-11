source "https://rubygems.org"

CI = ENV["CI"] == "true"

# gemspec

gem "oj"

if CI
  gem "digest-sha3"
else
  gem "digest-sha3", git: "https://github.com/steakknife/digest-sha3-ruby.git" # this fork compiles successfully on latest linux
end

gem "rlp"

group :development do
  gem "rspec-core"
  gem "rspec-mocks"
  gem "rspec-expectations"
end
