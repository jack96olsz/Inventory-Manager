#!/bin/bash
rm ../resources/data.yml
set -x
ruby load_inventory.rb cd_sellers.csv
ruby search_inventory.rb artist Nas
ruby load_inventory.rb music_merchant.csv
ruby search_inventory.rb album matic
echo "ruby purchase.rb "
read inventory_id
ruby purchase.rb ${inventory_id}
ruby search_inventory.rb album stillmatic