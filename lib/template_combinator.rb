

def tempate_combinator(file)
  puts  File.join(File.dirname(__FILE__),'template_combinator',file+'.rb')
  require File.join(File.dirname(__FILE__),'template_combinator',file+'.rb')
end


tempate_combinator('file_contents')
tempate_combinator('template_node')
tempate_combinator('haml_combinator')
