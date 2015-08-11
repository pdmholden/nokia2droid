#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'nokogiri'
require 'vcardigan'

def forward_convert options
  src = File.open(options.filename)
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

  if options.dump
    print "Surname: ", doc.at_xpath("//c:FamilyName").children.to_s, "\n"
    print "Name: ", doc.at_xpath("//c:GivenName").children.to_s, "\n"
    print "Number: ", doc.at_xpath("//c:Number").children.to_s, "\n\n"
  end

  # puts dst
  src.close
end

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-f", "--file NAME", "File to convert") do |f|
    options.filename = f
  end
  opts.on("-d", "--dump", "Show the contact data on stdout") do |x|
    options.dump = x
  end
end.parse!

forward_convert options
