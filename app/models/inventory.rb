class Inventory < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Inventory"

  def self.find_available_sku(skus)
  	where('Product_SubSku_Short' => skus.map(&:Product_SubSku_Short)).where('Current_Stock > 0').select('Product_SKU, Product_SubSku_Short')
  end
end
