require_relative "../lib/DataStore.rb"

# TODO: use proper casing
field_name = ARGV[0].downcase
substring = ARGV[1].nil? ? "" : ARGV[1].downcase
data_store = DataStore.new
output = ""

case field_name
when "artist", "album"
  inventory_items = data_store.get_inventory_items_by_field_name(field_name, substring)
  inventory_items.sort_by! { |item| item.send(field_name).downcase }
when "released"
  inventory_items = data_store.get_inventory_items_by_field_name("release_year", substring)
  inventory_items.sort_by! { |item| item.send("release_year").downcase }.reverse!
when "format"
  inventory_items = data_store.get_inventory_items_by_format(substring) 
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
