#!/usr/bin/env ruby

#
# This script converts urxvt colour themes to termite colour themes.
# By John Hamelink <john@johnhamelink.com>
#

require_relative 'option'
require_relative 'line_scanner'
require_relative 'urxvt_reader'

reader = UrxvtReader.new(ARGV.first)
puts "# This theme was imported with urxvt_to_termite.rb"
puts "[colors]"
reader.options.each do |opt|
  puts "#{opt.key} = #{opt.value}"
end
