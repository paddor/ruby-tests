#! /opt/local/bin/ruby

require 'rubygems'
require 'hpricot'
require 'term/ansicolor'

include Term::ANSIColor

config = $<.read
config[/\s*\n\s*/] = ''
config = Hpricot.XML config
#path   = '/configuration-data/hierarchy/[@name="xdsl"]/[@name="service-profile"]/instance'
#path   = '//[@name="service-profile"]//[@type="Xdsl::ProfileIndex"]/'
#path   = '//[@type="Xdsl::ProfileIndex"]'
#
#
#config.search(path).each do |profile|
#  num    = profile.inner_text
##  name   = profile.at 'parameter[@name=name]'
##  active = profile.at 'parameter[@name=active]'
##  puts "%3s => %s/%s (default=%s)" % [ num.inner_text, name.inner_text, active.inner_text, active['is-default'] ]
#  puts num
#end



path = '/configuration-data/[@name="configure"]/[@name="system"]/[@name="security"]/[@name="operator"]/instance'
config.search(path).each do |o|
  next unless o.at('res-id').inner_text == 'isadmin'
  o.search(:parameter).each do |p|
    name    = p[:name]
    value   = p.inner_text
    default = p[:'is-default'] == "yes"
    name = if default
      name.red
    else
      name.green
    end
    puts "#{name} => #{value}"
  end
end
