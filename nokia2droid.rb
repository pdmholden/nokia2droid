#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'nokogiri'
require 'vcardigan'

def forward_convert in_filename
  src = File.open(in_filename)
  doc = Nokogiri::XML(src)
  dst = VCardigan.create(:version => '4.0')

  unless doc.at_xpath("//c:Notes").nil?
    dst.note doc.at_xpath("//c:Notes").children.to_s
  end
  dst.tel doc.at_xpath("//c:Number").children.to_s, :type => 'CELL'
  dst.name doc.at_xpath("//c:FamilyName").children.to_s,
    doc.at_xpath("//c:GivenName").children.to_s
  dst.fullname doc.at_xpath("//c:GivenName").children.to_s + doc.at_xpath("//c:FamilyName").children.to_s
  # FN mandatory for vcard?

  src.close
end

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-f", "--file NAME", "File to convert") do |f|
    options.filename = f
  end
end.parse!

forward_convert options.filename
