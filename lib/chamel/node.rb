class Node

  attr_accessor :type, :input_file, :file_contents, :children
  
  attr_accessor :views_directory, :file_ext
  
  def initialize(input_file=nil,type=:parent, file_ext=nil)
    raise "Please specify input file" unless input_file
    @type = type
    @input_file = input_file
    @children = []
    @file_ext = file_ext
    @file_content = FileContents.new(@input_file)

    views_directory

  end
  
  def identify_partials
    @file_content.each_with_index do |line,index|
      if is_line_partial? line
        puts line
        puts partial_file_path(line)
        @children << Node.new(partial_file_path(line),:child,@file_ext)
        
      end
    end
  end
  
  def is_line_partial?(line)
    line.to_s =~ /^\= render :partial/
  end
  
  def partial_file_path(line)
    line =~ /:partial => "(.*?)",/
    path = $1.split("/")
    path[path.size - 1] = "_#{path[path.size - 1]}#{@file_ext}"
    File.join(views_directory,path)
  end
  
  def views_directory
    return @views_directory if @views_directory 
    @input_file =~ /(.*)(\/views)/
    @views_directory = "#{$1}#{$2}"
  end
end