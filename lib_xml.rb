#! /opt/local/bin/ruby

require 'rubygems'
require 'libxml'
require 'libxml/hpricot'
require 'term/ansicolor'

include Term::ANSIColor
Term::ANSIColor.coloring = STDOUT.tty?

def run_pager
  return if PLATFORM =~ /win32/
  return unless STDOUT.tty?

  read, write = IO.pipe

  unless Kernel.fork # Child process
    STDOUT.reopen(write)
    STDERR.reopen(write) if STDERR.tty?
    read.close

    write.close
    return
  end

  # Parent process, become pager
  STDIN.reopen(read)
  read.close
  write.close

  ENV['LESS'] = 'FSRX' # Don't page if the input is short enough

  Kernel.select [STDIN] # Wait until we have input before we start the pager
  pager = ENV['PAGER'] || 'less'
  exec pager rescue exec "/bin/sh", "-c", pager
end
run_pager

80.times do
  puts "bla bla"
end

config = LibXML::XML::Document.file ARGV.first

path = '/configuration-data/*[@name="configure"]/*[@name="system"]/*[@name="security"]/*[@name="operator"]/instance'
config.search(path).each do |o|
  next unless o.at('res-id').inner_xml == 'isadmin'
  o.search('parameter').each do |p|
    name    = p[:name]
    value   = p.inner_xml
    default = p[:'is-default'] == "yes"
    name = if default
      name.red
    else
      name.green
    end
    puts "#{name} => #{value}"
  end
end
