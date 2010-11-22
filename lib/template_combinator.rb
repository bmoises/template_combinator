Dir[ File.join(File.dirname(__FILE__),'template_combinator','*.rb')].each { |f| 
  require f
}