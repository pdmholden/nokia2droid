#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'nokogiri'

def forward_convert filename
    src = File.open(filename)
    doc = Nokogiri::XML(src)
    # p doc.at_xpath("//c:Notes").children.to_s
    p doc.at_xpath("//c:Number").children.to_s
    p doc.at_xpath("//c:FamilyName").children.to_s
    p doc.at_xpath("//c:GivenName").children.to_s
end

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-f", "--file NAME", "File to convert") do |f|
    options.filename = f
  end
end.parse!

forward_convert options.filename
