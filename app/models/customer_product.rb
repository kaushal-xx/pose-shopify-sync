class CustomerProduct < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "SO__t_sourcing_Final"

  def self.call_store_procedure
  	 ActiveRecord::Base.establish_connection(:secondary).connection.execute("call SO__001_CALL()")
  end

  def self.find_product_sku(email)
  	where('Email' => email).pluck('Product_SKU')
  end
end
