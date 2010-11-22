class TemplateNode

  attr_accessor :type, :input_file, :file_contents, :children
  
  attr_accessor :views_directory, :line_number, :line
  
  def initialize(input_file=nil,type=:parent)
    raise "Please specify input file" unless input_file
    @type = type
    @input_file = input_file
    @children = {} # since this is based on line numbers, this should be unique
    @file_content = FileContents.new(@input_file)
    views_directory
  end
  
  def identify_partials
    @file_content.each_with_index do |line,index|
      if is_line_partial? line
        #child = TemplateNode.new(partial_file_path(line),:child)
        child = eval("#{self.class}.new(partial_file_path(line),:child)")
        child.line_number = index 
        child.line = line
        begin
          child.identify_partials
          @children[index] = child
        rescue => e
          pp e
          puts "Encountered some error while loading: #{partial_file_path(line)}"
        end
      end
    end
  end
    
  def partial_file_path(line)
    line =~ /:partial => ("|')(.*?)("|'),?/
    path = $2.split("/")
    path[path.size - 1] = "_#{path[path.size - 1]}#{file_ext}"
    path = File.join(views_directory,path)
    
    if File.exists?(path) # app/views/foo/bar.ext
      return path
    elsif File.exists?(File.join(File.dirname(@input_file),File.basename(path))) # current working directory for file
      return File.join(File.dirname(@input_file),File.basename(path))
    else
      puts " ****** "
      puts line
      line =~ /:partial => ("|')(.*?)("|'),?/
      puts $2
      puts " ****** "
      raise "Failed to get file location: #{line}"
    end  
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
  
  def to_s(file_handle,counter=0)
    @file_content.each_with_index do |line,index|
      if @children[index]
        puts @children[index].line 
        pp parse_locals(@children[index].line)
        file_handle.puts "#{' '*(counter+2)}- #{'#'*(counter+2)}"
        
        parse_locals(@children[index].line).each do |key,value|
          file_handle.puts "#{' '*(counter+2)}- #{key}=#{value}"
        end
        
        @children[index].to_s(file_handle,counter+2)
        file_handle.puts "#{' '*(counter+2)}- #{'#'*(counter+2)}"
      else
        file_handle.puts "#{' '*(counter)}#{line}"
      end
    end
  end
  
  private
  
    def is_line_partial?(line)
      raise "Specify in your class"
    end
    
    def file_ext
      raise "Specify in your class"
    end
      
    def parse_locals(line) # must return a hash
      raise "Specify in your class"
    end
    
    def output_file
      raise "Specify in your class"
    end
  
end