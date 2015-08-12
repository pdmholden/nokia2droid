#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'nokogiri'
require 'vcardigan'

def forward_convert in_filename, dump=false
  if File.directory? in_filename
    return
  end

  src = File.open(in_filename)
  doc = Nokogiri::XML(src)
  vcf = VCardigan.create(:version => '3.0')

  unless doc.errors.empty?
    p "#{in_filename} is not an XML file"
    return
  end

  unless doc.at_xpath("//c:Notes").nil?
    vcf.note doc.at_xpath("//c:Notes").children.to_s
  end
  vcf.tel doc.at_xpath("//c:Number").children.to_s, :type => 'CELL'
  vcf.name doc.at_xpath("//c:FamilyName").children.to_s,
    doc.at_xpath("//c:GivenName").children.to_s
  # FN listed in surname-family name order, accoring to Asian tradition
  # no space, assumes name in Chinese characters
  vcf.fullname doc.at_xpath("//c:FamilyName").children.to_s +
    doc.at_xpath("//c:GivenName").children.to_s
  # FN mandatory for vcard?

  if dump
    print "Surname: ", doc.at_xpath("//c:FamilyName").children.to_s, "\n"
    print "Name: ", doc.at_xpath("//c:GivenName").children.to_s, "\n"
    print "Number: ", doc.at_xpath("//c:Number").children.to_s, "\n\n"
  end

  # puts vcf
  out_filename = File.dirname(in_filename) + File::SEPARATOR +
    File.basename(in_filename, ".*") + ".vcf"
  File.open(out_filename, "w") do |dst|
    dst.write(vcf)
  end
  src.close
end

options = OpenStruct.new
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-f", "--file NAME", "File to convert") do |f|
    options.filename = File.absolute_path(f)
  end
  opts.on("-d", "--dump", "Show the contact data on stdout") do |x|
    options.dump = x
  end
end.parse!

if File.directory? options.filename
  Dir.foreach options.filename do |file|
    forward_convert options.filename + File::SEPARATOR + file, options.dump
  end
else
  forward_convert options.filename, options.dump
end
