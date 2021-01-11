require_relative "../lib/DataStore.rb"

field_name = ARGV[0].nil? ? "" : ARGV[0].downcase
substring = ARGV[1].nil? ? "" : ARGV[1].downcase
data_store = DataStore.new
output = ""

# Get sorted items by field_name
case field_name
when "artist", "album"
  inventory_items = data_store.get_inventory_items_by_field_name(field_name, substring)
  inventory_items.sort_by! { |item| item.send(field_name).downcase }
when "released"
  inventory_items = data_store.get_inventory_items_by_field_name("release_year", substring)
  inventory_items.sort_by! { |item| item.send("release_year").downcase }.reverse!
when "format"
  case substring
  when "cd"
    format_field_name = "cd_quantity"
  when "tape"
    format_field_name = "tape_quantity"
  when "vinyl"
    format_field_name = "vinyl_quantity"
  end
  inventory_items = data_store.get_inventory_items_by_format(format_field_name) 
end

if inventory_items.nil?
  output = "Invalid field name: #{field_name}"
elsif inventory_items.empty?
  output = "No Results"
else
  inventory_items.each do |item|
    output << item.to_s + "\n"
  end
end

puts output
