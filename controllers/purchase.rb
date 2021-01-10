require_relative "../lib/DataStore.rb"

inventory_id = ARGV[0]
data_store = DataStore.new
output = "Removed 1 "
found = false
# TODO: break loop once item is found (across app?)
# TODO: move new lines to interface (across app)
# TODO: move purchase loop to DataStore if possible (cut out returning all values twice)
#       return found item and perform rest of operations
inventory_items = data_store.get_all_inventory_items

if inventory_items.empty?
  puts "Inventory is empty\n\n"
else
  inventory_items.each do |item|
    identifiers = [
      item.cd_inventory_identifier,
      item.tape_inventory_identifier,
      item.vinyl_inventory_identifier,
    ]

    if identifiers.include?(inventory_id)
      found = true
      # Decrement quanity
      case identifiers.index(inventory_id)
      when 0 # CD
        quanity = item.cd_quantity
        output << "cd "
      when 1 # Tape
        quanity = item.tape_quantity
        output << "tape "
      when 2 # Vinyl
        quanity = item.vinyl_quantity
        output << "vinyl "
      end
      output << "of #{item.album} by #{item.artist} from the inventory\n\n"
      if quanity == 0
        output = "Item out of stock: " + inventory_id + "\n\n"
      else
        quanity -= 1
        item = data_store.update_quantity_by_inventory_id(inventory_id, quanity)
      end

      # Output purchased item
      puts output
      break
    end
  end
  puts "Item not found: " + inventory_id + "\n\n" unless found
end
