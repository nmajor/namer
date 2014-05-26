require 'whois'
require 'retriable'
require 'twitter'
require 'yaml'

require_relative "models/namer.rb"

puts
# s1 = Namer.new
# puts s1.domains.inspect
# puts
# s2 = Namer.new 'hatefull'
# puts s2.domains.inspect
if ARGV[0]
    puts Namer.new(ARGV[0]).availability.inspect
else
    n = Namer.new
    puts n.availability.inspect
end