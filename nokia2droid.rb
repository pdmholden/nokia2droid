#!/usr/bin/env ruby

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

p options
p ARGV
