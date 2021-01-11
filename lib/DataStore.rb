require "yaml/store"
require_relative "../models/InventoryItem.rb"

# TODO: break loop once item is found (across app?)

# In lieu of not being able to use a database
class DataStore
  def initialize
    @store = YAML::Store.new("../resources/data.yml")

    @store.transaction do
      @store[:inventory_items] = [] if @store[:inventory_items].nil?
    end
  end

  #   Create
  def insert_inventory_items(inventory_items)
    @store.transaction do
      @store[:inventory_items].concat(inventory_items)
    end
  end

  #   Create/Update
  # TODO: match items regardles of capitalization
  def save_inventory_items(inventory_items)
    @store.transaction do
      inventory_items.each do |new_item|
        found = false
        @store[:inventory_items].each do |item|
          if item.artist == new_item.artist &&
             item.album == new_item.album &&
             item.release_year == new_item.release_year
            found = true

            # Update quantities
            item.cd_quantity += new_item.cd_quantity
            item.tape_quantity += new_item.tape_quantity
            item.vinyl_quantity += new_item.vinyl_quantity

            # Add unique identifiers if they don't exist
            item.cd_inventory_identifier = new_item.cd_inventory_identifier if item.cd_inventory_identifier.empty?
            item.tape_inventory_identifier = new_item.tape_inventory_identifier if item.tape_inventory_identifier.empty?
            item.vinyl_inventory_identifier = new_item.vinyl_inventory_identifier if item.vinyl_inventory_identifier.empty?

            break
          end
        end
        @store[:inventory_items].push(new_item) unless found
      end
    end
  end

  #   Read
  def get_all_inventory_items
    @store.transaction do
      return @store[:inventory_items]
    end
  end

  def get_inventory_items_by_field_name(field_name, substring)
    inventory_items = []
    @store.transaction do
      @store[:inventory_items].each do |item|
        field_value = item.send(field_name).dup.to_s.downcase
        if field_value.include?(substring)
          inventory_items.push(item)
        end
      end
    end
    return inventory_items
  end

  def get_inventory_items_by_format(format)
    inventory_items = []
    case format
    when "cd"
      field_name = "cd_quantity"
    when "tape"
      field_name = "tape_quantity"
    when "vinyl"
      field_name = "vinyl_quantity"
    end

    @store.transaction do
      @store[:inventory_items].each do |item|
        if item.send(field_name) > 0
          inventory_items.push(item)
        end
      end
    end
    inventory_items.sort_by! { |item| item.send(field_name) }.reverse!

    return inventory_items
  end

  #   Update
  def purchase_by_inventory_id(inventory_id)
    response = false
    @store.transaction do
      @store[:inventory_items].each do |item|
        identifiers = [
          item.cd_inventory_identifier,
          item.tape_inventory_identifier,
          item.vinyl_inventory_identifier,
        ]

        if identifiers.include?(inventory_id)
          # Decrement quanity unless item is out of stock
          # TODO: include out of stock message
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
          # TODO: test if item has updated quantity
          break
        end
      end
      # TODO: test if this gets returned after item return or only when no item is returned after loop
      #       test what is returned without this statement and when no item is returned. Maybe move this to purchase.rb
      # return "Item not found: " + inventory_id + "\n\n"
    end
    return response
  end

  #   Delete
  # TODO: fix delete
  def delete_inventory_item(inventory_item)
    @store.transaction do
      @store[:inventory_items].delete(inventory_item)
    end
  end
end
