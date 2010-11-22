class TemplateNode

  attr_accessor :type, :input_file, :file_contents, :children
  
  attr_accessor :views_directory, :file_ext, :line_number, :line
  
  def initialize(input_file=nil,type=:parent, file_ext=nil)
    raise "Please specify input file" unless input_file
    @type = type
    @input_file = input_file
    @children = {} # since this is based on line numbers, this should be unique
    @file_ext = file_ext
    @file_content = FileContents.new(@input_file)

    views_directory

  end
  
  def identify_partials
    @file_content.each_with_index do |line,index|
      if is_line_partial? line
        child = TemplateNode.new(partial_file_path(line),:child,@file_ext)
        child.line_number = index 
        child.line = line
        begin
          child.identify_partials
          @children[index] = child
        rescue 
          puts "Encountered some error while loading: #{partial_file_path(line)}"
        end
      end
    end
  end
  
  def is_line_partial?(line)
    line.to_s =~ /\= render :partial/
  end
  
  def partial_file_path(line)
    line =~ /:partial => "(.*?)",?/
    path = $1.split("/")
    path[path.size - 1] = "_#{path[path.size - 1]}#{@file_ext}"
    File.join(views_directory,path)
  end
  
  def views_directory
    return @views_directory if @views_directory 
    @input_file =~ /(.*)(\/views)/
    @views_directory = "#{$1}#{$2}"
  end
  
  def write_out_template
    File.open(output_file,'w') do |f|
      yield f
    end
    puts "Wrote out compiled template: #{output_file}"
  end
  
  def to_s(file_handle)
    @file_content.each_with_index do |line,index|
      if @children[index]
        @children[index].to_s(file_handle)
      else
        file_handle.puts line
      end
    end
  end
  
  private
    def output_file
      @input_file.gsub(@file_ext,".chamel")
    end
  
end