class FileContents
  attr_accessor :path, :contents
  
  def initialize(file_path)
    @file_path = file_path
    @contents = []
    load
  end
  
  def load
    puts "Loading: #{@file_path}"
    f = File.open(@file_path,'r')
    while(line = f.gets)
      @contents << line
    end
    f.close
  end
  
  def each_with_index
    @contents.each_with_index do |line,index|
      yield line,index
    end
  end
end