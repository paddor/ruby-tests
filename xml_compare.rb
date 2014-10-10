#! /opt/local/bin/ruby

require 'rubygems'
require 'libxml'
require 'libxml/hpricot'
require 'term/ansicolor'

include Term::ANSIColor

config = LibXML::XML::Document.file ARGV.first
config2 = LibXML::XML::Document.file ARGV[1]

path = '/configuration-data/*[@name="configure"]/*[@name="system"]/*[@name="security"]/*[@name="operator"]/instance'

node1 = nil
node2 = nil

config.search(path).each do |o|
  next unless o.at('res-id').inner_xml == 'isadmin'
  node1 = o
  break
end

config2.search(path).each do |o|
  next unless o.at('res-id').inner_xml == 'isadmin'
  node2 = o
  break
end

puts node1 == node2
