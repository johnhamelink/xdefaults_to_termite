#!/usr/bin/env ruby

#
# This script converts urxvt colour themes to termite colour themes.
# By John Hamelink <john@johnhamelink.com>
#

require_relative 'option'
require_relative 'line_scanner'
require_relative 'urxvt_reader'

reader = UrxvtReader.new(ARGV.first)
reader.options.each do |opt|
  puts "#{opt.key} = #{opt.value}"
end
