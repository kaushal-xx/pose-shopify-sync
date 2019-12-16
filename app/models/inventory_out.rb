class InventoryOut < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "IM__Inventory_Out"

  validates :shopify_line_item_id, uniqueness: true

  def self.find_available_sku(skus)
  	where('Product_SKU' => skus).where('Current_Stock > 0').pluck('Product_SKU')
  end

  def self.update_inventory(shopify_order_id, shopify_line_item_id, product_sub_sku, order_name, quantity, order_canceled = false)
    order_canceled = order_canceled ? 'True' : 'False'
  	obj = where('shopify_order_id' => shopify_order_id, 'shopify_line_item_id' => shopify_line_item_id, 'CountOut' => quantity).first
    if obj.blank?
  		create('shopify_order_id' => shopify_order_id, 'shopify_line_item_id' => shopify_line_item_id, 'Prod_SubSku_Short' =>  product_sub_sku, 'Order#' => order_name, 'CountOut' => quantity, 'order_canceled' => order_canceled)
    else
      obj.update('order_canceled' => order_canceled)
  	end
  end
end
