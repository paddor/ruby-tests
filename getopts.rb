#! /usr/bin/env ruby

# -- Synopsis
#
# hello: greets user, demonstrates command line parsing
#
# == Usage
#
# hello [OPTION] ... DIR
#
# -h, --help:
#    show help
#
# --repeat x, -n x:
#    repeat x times
#
# --name [name]:
#    greet user by name, if name not supplied default is John
#
# DIR: The directory in which to issue the greeting.

require 'getoptlong'
require 'rdoc/usage'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--repeat', '-n', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--name', GetoptLong::OPTIONAL_ARGUMENT ]
)

repeat = 1
name = "John"
opts.each do |opt, arg|
  case opt
  when '--help'
    RDoc::usage
  when '--repeat'
    repeat = arg.to_i
  when '--name'
    name = arg.to_s if arg
  end
end

if ARGV.length != 1
  puts "Missing dir argument (try --help)"
  exit 0
end

dir = ARGV.shift
#Dir.chdir(dir)
#puts "pwd: " + Dir.pwd
#puts Dir.entries Dir.pwd

repeat.times do
	puts "Hello#{", " + name if name}"
end

puts "dir: #{dir}"

# vim: et ts=2 sw=2
