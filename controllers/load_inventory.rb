require_relative "../lib/FileUtil.rb"
require_relative "../lib/DataStore.rb"

# Folder structure could have been better to accommodate absolute paths
# Otherwise, remove "../resources/" and put files in controllers or anywhere else
file_name = "../resources/#{ARGV[0]}"
data_store = DataStore.new

begin
  # Convert file to array of InventoryItems
  inventory_items = FileUtil.file_to_inventory_items(file_name)

  # Save InventoryItems to DataStore (data.yml)
  data_store.save_inventory_items(inventory_items)

# Catch errors from invalid file names
rescue SystemCallError => e
  puts "File not found: " + file_name
rescue StandardError => e
  puts e.message
rescue => e
  print_exception(e, false)
end
