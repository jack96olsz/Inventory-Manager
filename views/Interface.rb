# TODO: consider making a static class
# @input isn't needed
# @output can be handled by user and passed into print_menu(output)
# add return statements
class Interface
  def initialize
    @input = ""
    @output = ""
    @load_inventory = "../controllers/load_inventory.rb"
    @search_inventory = "../controllers/search_inventory.rb"
    @purchase = "../controllers/purchase.rb"
  end

  def process_input(input)
    @input = input

    case @input
    when "load_inventory", "l"
      print "Enter file_name: "
      file_name = gets.chomp
      @output = `ruby #{@load_inventory} #{file_name}`
      @output << "Loaded to inventory: " + file_name
      # TODO: Reprint Menu after search results
    when "search_inventory", "s"
      print "Enter field_name: "
      field_name = gets.chomp

      print "Enter substring: "
      substring = gets.chomp
      @output = "\nSearch Criteria: #{field_name} #{substring}\n\n"
      @output << `ruby #{@search_inventory} #{field_name} #{substring}`
    when "purchase", "p"
      print "Enter inventory_id: "
      inventory_id = gets.chomp
      @output = `ruby #{@purchase} #{inventory_id}`
    when "quit", "q"
      @output = false
    else
      @output = "Invalid command: " + @input
    end
  end

  def print_menu
    puts "\n" +
           "\n Enter command_name (or shortcut):" +
           "\n - load_inventory (l)" +
           "\n - search_inventory (s)" +
           "\n - purchase (p)" +
           "\n - quit (q)" +
           "\n#{@output}"
  end

  def clear_output
    system "cls"
    system "clear"
  end

  # TODO: use attr_reader
  def input
    @input
  end

  def output
    @output
  end
end
