class HamlCombinator < TemplateNode

  private
    def is_line_partial?(line)
      line.to_s =~ /\= render :partial/
    end
  
    def file_ext
      ".html.haml"
    end
    
    def parse_locals(line)
      line =~ /(.*)?:locals => \{(.*)?\}(.*)?/
      if $2
        res = {}
        $2.split(",").each do |h|
          h =~ /:(.*)?\b\s?=>\s?(.*)?/
          res[$1] = $2
        end
        return res
      end
      return {}
    end
  
    def output_file
      @input_file.gsub(file_ext,".chamel")
    end
end