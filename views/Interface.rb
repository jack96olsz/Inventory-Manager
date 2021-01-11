class Interface
  def initialize
    @load_inventory = "../controllers/load_inventory.rb"
    @search_inventory = "../controllers/search_inventory.rb"
    @purchase = "../controllers/purchase.rb"
  end

  def process_input(input)
    case input
    when "load_inventory", "l"
      # Get input
      print "Enter file_name: "
      file_name = gets.chomp

      # Get output
      output = `ruby #{@load_inventory} #{file_name}`
      output = "Loaded to inventory: #{file_name}" if output.empty?
    when "search_inventory", "s"

      # Get input
      print "Enter field_name: "
      field_name = gets.chomp

      # Get input
      print "Enter substring: "
      substring = gets.chomp

      # Get output
      output = "\nSearch Criteria: #{field_name} #{substring}\n\n"
      output << `ruby #{@search_inventory} #{field_name} #{substring}`
      
      # Print menu after output so user doesn't need to scroll to the top
      output << print_menu("")
    when "purchase", "p"
      # Get input
      print "Enter inventory_id: "
      inventory_id = gets.chomp

      # Get output
      output = "\n"
      output << `ruby #{@purchase} #{inventory_id}`
    when "quit", "q"
      output = false
    else
      output = "Invalid command: " + input
    end
    return output
  end

  def print_menu(output)
    return "\n Enter command_name (or shortcut):" +
           "\n - load_inventory (l)" +
           "\n - search_inventory (s)" +
           "\n - purchase (p)" +
           "\n - quit (q)" +
           "\n#{output}"
  end

  def clear_output
    system "cls"
    system "clear"
  end
end
