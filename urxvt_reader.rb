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
