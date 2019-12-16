class CustomerProduct < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "SO__t_sourcing_Final"

  def self.call_store_procedure
  	 ActiveRecord::Base.establish_connection(:secondary).connection.execute("call SO__001_CALL()")
  end

  def self.find_product_sku(email)
  	where('Email' => email).pluck('Product_SKU')
  end

  def self.find_shopify_product_id(email)
  	skus = where('Email' => email).pluck('shopify_product_id')
  	Product.where('ProductSKU' => skus).pluck('shopify_variant_id')
  end
  def self.find_shopify_variant_id(email)
  	obj_skus = CustomerProduct.where('Email' => email).select('Product_SKU, Product_SubSku_Short')
  	obj_skus = Inventory.find_available_sku(obj_skus)
  	data = Product.where('ProductSKU' => obj_skus.map(&:Product_SKU)).select('ProductSKU, shopify_variant_id')
    skus = {}
    data.each do |obj|
      skus[obj.shopify_variant_id] = obj_skus.select{|s| s.Product_SKU == obj.ProductSKU}.first.try(:Product_SubSku_Short)
    end
    skus
  end
end
