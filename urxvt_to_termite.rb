#!/usr/bin/env ruby

require 'pry'


#
# This script converts urxvt colour themes to termite colour themes.
# By John Hamelink <john@johnhamelink.com>
#


class Option
  attr_accessor :key, :value

  def initialize(key, value)
    self.key, self.value = key, value
  end
end

class LineScanner
  attr_accessor :raw_line, :line, :result

  def initialize(line)
    self.raw_line, self.line = line, line
    self.result = {}

    clean
    parse
  end

  def clean
    # Replace tabs with spaces
    self.line.gsub!("\t", " ")
    # Remove excess spaces & trim whitespace
    self.line = self.line.split.join(" ").strip
    # Normalise case
    self.line.downcase!
    # Remove namespaces
    self.line.gsub!(/(urxvt|xft|xterm)(\.|\*)?/, "")
    # Remove Asterisks, as they seem to be interchangeable
    self.line.gsub!(/[\!\*\:]/, "")
  end

  def parse
    if self.line =~ /^col(o|ou)r\d?\s*/
      # We've found a colour scheme
      self.result[:key]   = line.scan(/^[a-z0-9]+/).first
      self.result[:value] = line.scan(/^[a-z0-9]*\s*(.+)$/).last.first
    elsif self.line =~ /^background\d?\s*/
      # We've found a background colour
      self.result[:key]   = "background"
      self.result[:value] = line.scan(/^[a-z0-9]*\s*(.+)$/).last.first
    elsif self.line =~ /^foreground\d?\s*/
      # We've found a foreground colour
      self.result[:key]   = "foreground"
      self.result[:value] = line.scan(/^[a-z0-9]*\s*(.+)$/).last.first
    elsif self.line =~ /^cursorcol(o|ou)r\d?\s*/
      # We've found a foreground colour
      self.result[:key]   = "cursor"
      self.result[:value] = line.scan(/^[a-z0-9]*\s*(.+)$/).last.first
    else
      self.result = nil
    end
  end
end

class UrxvtReader

  attr_accessor :file_path, :options

  def initialize(file_path)
    self.file_path = file_path
    self.options   = []

    read_file

    return self.options
  end

  def read_file
    file = File.open(self.file_path).read
    file.each_line do |line|
      option = LineScanner.new(line).result
      unless option.nil?
        self.options << Option.new(option[:key], option[:value])
      end
    end
  end

end

reader = UrxvtReader.new(ARGV.first)
reader.options.each do |opt|
  puts "#{opt.key} = #{opt.value}"
end
