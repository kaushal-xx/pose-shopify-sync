class CustomerLogin < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Customer_Login"

  def self.data_insert(shopify_customer_id)
    shopify_customer = Shop.get_customer(shopify_customer_id)
    if CustomerLogin.find_by_Email(shopify_customer.email).blank?
      CustomerLogin.create({'Email' => shopify_customer.email})
    end
    CustomerProduct.call_store_procedure
    shopify_customer.email
  end

  def self.data_delete(shopify_customer_id)
    shopify_customer = Shop.get_customer(shopify_customer_id)
    obj = CustomerLogin.find_by_Email(shopify_customer.email)
    obj.delete if obj.present?
    CustomerProduct.call_store_procedure
  end
end
