require_relative "../lib/FileUtil.rb"
require_relative "../lib/DataStore.rb"

# TODO: tell user where to put files or change
file_name = "../resources/#{ARGV[0]}"
data_store = DataStore.new

begin
  inventory_items = FileUtil.file_to_inventory_items(file_name)
  data_store.save_inventory_items(inventory_items)
rescue SystemCallError => e
  puts "File not found: " + file_name
rescue StandardError => e
  puts e.message
rescue => e
  print_exception(e, false)
end
