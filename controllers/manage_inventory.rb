require_relative '../views/Interface.rb'

interface = Interface.new
# interface.clear_output

while interface.output
  interface.print_menu
  input = gets.chomp.downcase

  interface.clear_output
  interface.process_input(input)
  interface.clear_output
end
# TODO: Apply prompt format to all output

# TODO: make each command individually runnable https://stackoverflow.com/questions/4244611/pass-variables-to-ruby-script-via-command-line