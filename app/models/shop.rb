class Shop < ActiveRecord::Base
  establish_connection(:production)
  self.table_name = "shops"

  include ShopifyApp::SessionStorage

  def api_version
    ShopifyApp.configuration.api_version
  end

  def set_store_session
  	sess = ShopifyAPI::Session.new(domain: self.shopify_domain, token: self.shopify_token, api_version: self.api_version)
    ShopifyAPI::Base.activate_session(sess)
  end

  def self.get_customer(customer_id)
    Shop.first.set_store_session
    ShopifyAPI::Customer.find(customer_id)
  end
end
