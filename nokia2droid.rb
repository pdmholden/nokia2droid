#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-f", "--file NAME", "File to convert") do |f|
    options.file = f
  end
end.parse!

p options.file
