require_relative '../views/Interface.rb'

interface = Interface.new
interface.clear_output

while interface.output
  interface.print_menu
  input = gets.chomp.downcase

  interface.clear_output
  interface.process_input(input)
  interface.clear_output
end