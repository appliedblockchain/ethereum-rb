# minispec

# ------------

# exec

def exec(cmd)
  puts "executing '#{cmd}':"
  # IO.popen cmd
  cmd = `CHECK=1 #{cmd}`
  puts cmd
  cmd
end


# ---------

def expect(source, cond, target)
  if ["equals", "is", "=", "eq", "=="].map{|s| s.to_sym}.include? cond
  source
    check_equality source, target
  elsif ["maps", "matches", "match_to", "=~", "~"].map{|s| s.to_sym}.include? cond
    check_match source, target
  else
    raise "TODO - method not implemented".inspect
  end
end

def check_equality(source, target)
  msg = "Spec failed #{source.inspect} not equal to #{target.inspect}"
  raise msg if source != target
end

def check_match(source, target)
  msg = "Spec failed #{source.inspect} not matching #{target.inspect}"
  raise msg if source !~ target
end


PATH = File.expand_path "../../", __FILE__
