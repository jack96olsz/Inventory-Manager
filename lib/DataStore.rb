require "yaml/store"
require_relative "../models/InventoryItem.rb"

# In lieu of not being able to use a database
# Could have used other storage methods but PStore seemed fun
class DataStore
  def initialize
    # Could change if folder structure was modified
    @store = YAML::Store.new("../resources/data.yml")

    # Create empty inventory_items in store to prevent nil errors
    @store.transaction do
      @store[:inventory_items] = [] if @store[:inventory_items].nil?
    end
  end

  #   Create/Update
  def save_inventory_items(inventory_items)
    @store.transaction do
      inventory_items.each do |new_item|
        found = false
        @store[:inventory_items].each do |item|
          # Does item already exist in the inventory? (ignore case)
          if item.artist.casecmp?(new_item.artist) &&
             item.album.casecmp?(new_item.album) &&
             item.release_year.casecmp?(new_item.release_year)
            found = true

            # Update quantities
            item.cd_quantity += new_item.cd_quantity
            item.tape_quantity += new_item.tape_quantity
            item.vinyl_quantity += new_item.vinyl_quantity

            # Add unique identifiers if they don't exist
            item.cd_inventory_identifier = new_item.cd_inventory_identifier if item.cd_inventory_identifier.empty?
            item.tape_inventory_identifier = new_item.tape_inventory_identifier if item.tape_inventory_identifier.empty?
            item.vinyl_inventory_identifier = new_item.vinyl_inventory_identifier if item.vinyl_inventory_identifier.empty?

            # Break loop after item is found
            break
          end
        end
        # Push item if it does not already exist in store
        @store[:inventory_items].push(new_item) unless found
      end
    end
  end

  #   Read
  def get_inventory_items_by_field_name(field_name, substring)
    inventory_items = []
    @store.transaction do
      @store[:inventory_items].each do |item|
        # Duplicate and downcase value to preserve original casing
        field_value = item.send(field_name).dup.to_s.downcase

        # Push item if its value contains the substring
        if field_value.include?(substring)
          inventory_items.push(item)
        end
      end
    end
    return inventory_items
  end

  def get_inventory_items_by_format(field_name)
    inventory_items = []

    # If no format was supplied
    if field_name.nil?
      @store.transaction do
        # Get all items
        inventory_items = @store[:inventory_items]
      end

      # Reverse sort all by CD, Tape, then Vinyl quantity (descending)
      inventory_items.sort_by! { |item| [item.cd_quantity, item.tape_quantity, item.vinyl_quantity] }.reverse!

      # If supplied format
    else
      @store.transaction do
        @store[:inventory_items].each do |item|
          # Find items with format in stock
          if item.send(field_name) > 0
            inventory_items.push(item)
          end
        end
      end
      # Reverse sort by format (descending)
      inventory_items.sort_by! { |item| item.send(field_name) }.reverse!
    end

    return inventory_items
  end

  #   Update
  def purchase_by_inventory_id(inventory_id)
    # Default response is false unless item is in stock
    response = false
    @store.transaction do
      @store[:inventory_items].each do |item|
        identifiers = [
          item.cd_inventory_identifier,
          item.tape_inventory_identifier,
          item.vinyl_inventory_identifier,
        ]

        # If item has supplied inventory_id
        if identifiers.include?(inventory_id)
          # Decrement quanity unless item is out of stock
          case identifiers.index(inventory_id)
          when 0 # CD
            unless item.cd_quantity == 0
              item.cd_quantity -= 1
              response = item
            end
          when 1 # Tape
            unless item.tape_quantity == 0
              item.tape_quantity -= 1
              response = item
            end
          when 2 # Vinyl
            unless item.vinyl_quantity == 0
              item.vinyl_quantity -= 1
              response = item
            end
          end
          # Break loop after item is found
          break
        end
      end
    end
    return response
  end
end
