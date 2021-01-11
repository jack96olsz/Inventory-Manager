require_relative "../lib/DataStore.rb"

inventory_id = ARGV[0]
data_store = DataStore.new
output = "Removed 1 "
# TODO: move new lines to interface (across app)
# TODO: move purchase loop to DataStore if possible (cut out returning all values twice)
#       return found item and perform rest of operations
item = data_store.purchase_by_inventory_id(inventory_id)

if item
  identifiers = [
    item.cd_inventory_identifier,
    item.tape_inventory_identifier,
    item.vinyl_inventory_identifier,
  ]

  # Decrement quanity
  case identifiers.index(inventory_id)
  when 0 # CD
    output << "cd "
  when 1 # Tape
    output << "tape "
  when 2 # Vinyl
    output << "vinyl "
  end
  output << "of #{item.album} by #{item.artist} from the inventory\n\n"
  # if quanity == 0
  #   output = "Item out of stock: " + inventory_id + "\n\n"
  # end

  # Output purchased item
  puts output
else
  # TODO: test item not found or out of stock or no inventory_id
  puts "Unable to purchase item: #{inventory_id}\n\n"
end
