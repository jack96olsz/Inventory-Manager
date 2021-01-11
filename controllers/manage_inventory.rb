require_relative '../views/Interface.rb'

interface = Interface.new
interface.clear_output
output = ""

while output
  puts interface.print_menu(output)
  input = gets.chomp.downcase

  interface.clear_output
  output = interface.process_input(input)
  interface.clear_output
end