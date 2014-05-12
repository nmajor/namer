require_relative "Namer.rb"

puts
s1 = Namer.new
puts s1.domains.inspect
puts
s2 = Namer.new 'hatefull'
puts s2.domains.inspect