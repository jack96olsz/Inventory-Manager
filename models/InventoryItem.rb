class InventoryItem
  attr_accessor \
    :artist,
    :album,
    :release_year,
    :cd_inventory_identifier,
    :cd_quantity,
    :tape_inventory_identifier,
    :tape_quantity,
    :vinyl_inventory_identifier,
    :vinyl_quantity

  def initialize(
    artist,
    album,
    release_year,
    cd_inventory_identifier,
    cd_quantity,
    tape_inventory_identifier,
    tape_quantity,
    vinyl_inventory_identifier,
    vinyl_quantity
  )
    @artist = artist
    @album = album
    @release_year = release_year
    @cd_inventory_identifier = cd_inventory_identifier
    @cd_quantity = cd_quantity
    @tape_inventory_identifier = tape_inventory_identifier
    @tape_quantity = tape_quantity
    @vinyl_inventory_identifier = vinyl_inventory_identifier
    @vinyl_quantity = vinyl_quantity
  end

  def to_s
    "Artist: #{@artist}\n" +
    "Album: #{@album}\n" +
    "Released: #{@release_year}\n" +
    (@cd_quantity == 0 ? "" : "CD(#{@cd_quantity}): #{@cd_inventory_identifier}\n") +
    (@tape_quantity == 0 ? "" : "Tape(#{@tape_quantity}): #{@tape_inventory_identifier}\n") +
    (@vinyl_quantity == 0 ? "" : "Vinyl(#{@vinyl_quantity}): #{@vinyl_inventory_identifier}\n")
  end
end

# "DB" Format
# artist | album | release_year | cd_inventory_identifier | cd_quantity | tape_inventory_identifier | tape_quantity | vinyl_inventory_identifier | vinyl_quantity
