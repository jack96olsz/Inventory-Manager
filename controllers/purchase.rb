require_relative "../lib/DataStore.rb"

inventory_id = ARGV[0]
data_store = DataStore.new
output = "Removed 1 "
item = data_store.purchase_by_inventory_id(inventory_id)

# Successful purchase
if item
  identifiers = [
    item.cd_inventory_identifier,
    item.tape_inventory_identifier,
    item.vinyl_inventory_identifier,
  ]

  # Continue to build ouput
  case identifiers.index(inventory_id)
  when 0 # CD
    output << "cd "
  when 1 # Tape
    output << "tape "
  when 2 # Vinyl
    output << "vinyl "
  end
  output << "of #{item.album} by #{item.artist} from the inventory\n"

  # Output purchased item
  puts output
else
  puts "Unable to purchase item: #{inventory_id}\n"
end
