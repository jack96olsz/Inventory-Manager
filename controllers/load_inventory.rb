require_relative "../lib/FileUtil.rb"
require_relative "../lib/DataStore.rb"

# def load_inventory(file_name)
# TODO: tell user where to put files or change
file_name = "../resources/" + ARGV[0]
data_store = DataStore.new

# TODO: Think about which level error should be handled
begin
  inventory_items = FileUtil.file_to_inventory_items(file_name)
  data_store.save_inventory_items(inventory_items)
  # TODO: save items to inventory.
  # TODO: DB options: JSON, CSV, PStore, YAML::Store https://stackoverflow.com/questions/20560353/best-way-to-store-data-with-pure-ruby-no-dependencies/20560834
  # TODO: each column is a key with an array of values. Search by key, return array. Find index. Get index of each column
rescue SystemCallError => e
  puts "File not found: " + file_name
rescue StandardError => e
  puts e.message
rescue => e
  print_exception(e, false)
end
# end
