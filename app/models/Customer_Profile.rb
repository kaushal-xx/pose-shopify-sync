class CustomerProfile < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Customer_Profile"
  default_scope ->{ order("email" => :asc) }

  validates :shopify_customer_id, uniqueness: true

  def self.data_insert(data)
    attr = {}
    Shop.first.set_store_session
    shopify_customer = ShopifyAPI::Customer.find(data['id'])
    metafields = shopify_customer.metafields || {}
    address = shopify_customer.default_address rescue nil
    address = shopify_customer.addresses.first if address.blank?
    attr['shopify_customer_id'] = shopify_customer.id
    attr['Email'] = shopify_customer.email
    attr['Cust_Date'] = shopify_customer.updated_at
    attr['First Name'] = shopify_customer.first_name
    attr['Last Name'] = shopify_customer.last_name
    attr['Accepts Marketing'] = shopify_customer.accepts_marketing
    attr['Total Orders'] = shopify_customer.orders_count
    attr['Cust_Tags'] = shopify_customer.tags
    attr['Note'] = shopify_customer.note
    attr['Tax Exempt'] = shopify_customer.tax_exempt
    if address.present?
        attr['Company'] = address.company
        attr['Address1'] = address.address1
        attr['Address2'] = address.address2
        attr['City'] = address.city
        attr['Province'] = address.province
        attr['Province Code'] = address.province_code
        attr['Country'] = address.country
        attr['Country Code'] = address.country_code
        attr['Zip'] = address.zip
        attr['Phone'] = address.phone
    end
    attr['Cust_chest_size'] = metafields.select{|s| s.key == 'chest_size_inches'}.last.try(:value)||''
    attr['Cust_midsection_size'] = metafields.select{|s| s.key == 'midsection_size_inches'}.last.try(:value)||''
    attr['Cust_seat_size'] = metafields.select{|s| s.key == 'seat_size_inches'}.last.try(:value)||''
    attr['Cust_torso_length'] = metafields.select{|s| s.key == 'torso_length_inches'}.last.try(:value)||''
    attr['special_access_code'] = ''
    attr['Product_Fit_Type_Pref'] = ''
    CustomerProfile.create(attr)
  end

  def data_update(data)
    attr = {}
    Shop.first.set_store_session
    shopify_customer = ShopifyAPI::Customer.find(data['id'])
    metafields = shopify_customer.metafields || {}
    address = shopify_customer.default_address rescue nil
    address = shopify_customer.addresses.first if address.blank?
    attr['shopify_customer_id'] = shopify_customer.id
    attr['Email'] = shopify_customer.email
    attr['Cust_Date'] = shopify_customer.updated_at
    attr['First Name'] = shopify_customer.first_name
    attr['Last Name'] = shopify_customer.last_name
    attr['Accepts Marketing'] = shopify_customer.accepts_marketing
    attr['Total Orders'] = shopify_customer.orders_count
    attr['Cust_Tags'] = shopify_customer.tags
    attr['Note'] = shopify_customer.note
    attr['Tax Exempt'] = shopify_customer.tax_exempt
    if address.present?
        attr['Company'] = address.company
        attr['Address1'] = address.address1
        attr['Address2'] = address.address2
        attr['City'] = address.city
        attr['Province'] = address.province
        attr['Province Code'] = address.province_code
        attr['Country'] = address.country
        attr['Country Code'] = address.country_code
        attr['Zip'] = address.zip
        attr['Phone'] = address.phone
    end
    attr['Cust_chest_size'] = metafields.select{|s| s.key == 'chest_size_inches'}.last.try(:value)||''
    attr['Cust_midsection_size'] = metafields.select{|s| s.key == 'midsection_size_inches'}.last.try(:value)||''
    attr['Cust_seat_size'] = metafields.select{|s| s.key == 'seat_size_inches'}.last.try(:value)||''
    attr['Cust_torso_length'] = metafields.select{|s| s.key == 'torso_length_inches'}.last.try(:value)||''
    attr['special_access_code'] = ''
    attr['Product_Fit_Type_Pref'] = ''
    self.update(attr)
  end
end
