require "csv"
require "securerandom"
require_relative "../models/InventoryItem.rb"

class FileUtil
  class << self
    # Convert file to an array of InventoryItems
    def file_to_inventory_items(file_name)
      file_array = []

      # If .csv
      if (File.extname(file_name) == ".csv")
        # Reads file to generic array
        file_array = CSV.read(file_name)
        # Convert array to InventoryItems and return
        return csv_array_to_inventory_items(file_array)
        # If .pipe
      elsif (File.extname(file_name) == ".pipe")
        # Reads file to generic array
        File.open(file_name) do |file|
          file.each do |line|
            file_array.push(line.chomp.split(" | "))
          end
        end
        # Convert array to InventoryItems and return
        return pipe_array_to_inventory_items(file_array)
      else
        raise StandardError.new "File extension not supported. Use .csv or .pipe"
      end

      return file_array
    end

    private

    def csv_array_to_inventory_items(file_array)
      inventory_items = []
      file_array.each do |item|
        # Store format downcased
        case item[2].downcase
        when "cd"
          inventory_items.push(InventoryItem.new(item[0], item[1], item[3], SecureRandom.uuid, 1, "", 0, "", 0))
        when "tape"
          inventory_items.push(InventoryItem.new(item[0], item[1], item[3], "", 0, SecureRandom.uuid, 1, "", 0))
        when "vinyl"
          inventory_items.push(InventoryItem.new(item[0], item[1], item[3], "", 0, "", 0, SecureRandom.uuid, 1))
        end
      end
      return inventory_items
    end

    def pipe_array_to_inventory_items(file_array)
      inventory_items = []
      file_array.each do |item|
        # Store format downcased
        case item[1].downcase
        when "cd"
          inventory_items.push(InventoryItem.new(item[3], item[4], item[2], SecureRandom.uuid, item[0].to_i, "", 0, "", 0))
        when "tape"
          inventory_items.push(InventoryItem.new(item[3], item[4], item[2], "", 0, SecureRandom.uuid, item[0].to_i, "", 0))
        when "vinyl"
          inventory_items.push(InventoryItem.new(item[3], item[4], item[2], "", 0, "", 0, SecureRandom.uuid, item[0].to_i))
        end
      end
      return inventory_items
    end
  end
end
