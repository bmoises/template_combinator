require 'lib/template_combinator.rb'
require 'pp'


raise "Please specify input file" unless ARGV[0] && File.exists?(ARGV[0])
parent_file = ARGV.first

main_node = HamlCombinator.new(parent_file, :parent)

main_node.identify_partials

# Write out template
main_node.write_out_template do |file_handle|
  main_node.to_s(file_handle)
end