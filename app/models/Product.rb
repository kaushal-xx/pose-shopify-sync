class Product < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Products"

  validates :shopify_variant_id, uniqueness: true

  def self.data_insert(data)
    attr = {} 
    Shop.first.set_store_session
    shopify_product = ShopifyAPI::Product.find(data['id'])
    metafields = shopify_product.metafields || {}
    variant = shopify_product.variants.first
    attr['shopify_product_id'] = shopify_product.id
    attr['shopify_variant_id'] = variant.id
    attr['Discontinued'] = ''
    attr['Published'] = shopify_product.published_at.present?
    attr['Brand'] = metafields.select{|s| s.key == 'brand'}.first.try(:value)||''
    attr['Brand_ID'] = variant.sku.split('-').first
    attr['Brand_Prod_ID'] = variant.sku.split('-').last.to_i
    attr['ProductSKU'] = variant.sku
    attr['Item'] = shopify_product.title
    # attr['Description'] = ActionController::Base.helpers.strip_tags(shopify_product.body_html)
    attr['Gender'] = metafields.select{|s| s.key == 'gender'}.first.try(:value)||''
    attr['Product_Type'] = metafields.select{|s| s.key == 'product_type'}.first.try(:value)||''
    attr['RawMat_Type'] = metafields.select{|s| s.key == 'rawmat_type'}.first.try(:value)||''
    attr['Product_Fit'] = metafields.select{|s| s.key == 'product_fit_type'}.first.try(:value)||''
    attr['Tags'] = shopify_product.tags
    attr['Option1Name'] = shopify_product.options.first.try(:name)||''
    attr['Option1Value'] = shopify_product.options.first.try(:values).try(:first)||''
    attr['Regular_Price'] = '$'+variant.price
    attr['Sale_Price'] = '$'+variant.price
    # attr['Design_Code'] = data['tag']
    # attr['Partnership'] = data['note']
    attr['Supplier'] = metafields.select{|s| s.key == 'company'}.first.try(:value)||''
    attr['Supplier_BarCode'] = metafields.select{|s| s.key == 'supplier_barcode'}.first.try(:value)||''
    attr['Stretchability'] = (metafields.select{|s| s.key == 'stretchability'}.first.try(:value)||'').present?
    Product.create(attr)
  end

  def data_update(data)
    attr = {} 
    Shop.first.set_store_session
    shopify_product = ShopifyAPI::Product.find(data['id'])
    metafields = shopify_product.metafields || {}
    variant = shopify_product.variants.first
    attr['shopify_product_id'] = shopify_product.id
    attr['shopify_variant_id'] = variant.id
    attr['Discontinued'] = ''
    attr['Published'] = shopify_product.published_at.present?
    attr['Brand'] = metafields.select{|s| s.key == 'brand'}.first.try(:value)||''
    attr['Brand_ID'] = variant.sku.split('-').first
    attr['Brand_Prod_ID'] = variant.sku.split('-').last.to_i
    attr['Item'] = shopify_product.title
    # attr['Description'] = shopify_product.body_html
    attr['Gender'] = metafields.select{|s| s.key == 'gender'}.first.try(:value)||''
    attr['Product_Type'] = metafields.select{|s| s.key == 'product_type'}.first.try(:value)||''
    attr['RawMat_Type'] = metafields.select{|s| s.key == 'rawmat_type'}.first.try(:value)||''
    attr['Product_Fit'] = metafields.select{|s| s.key == 'product_fit_type'}.first.try(:value)||''
    attr['Tags'] = shopify_product.tags
    attr['Option1Name'] = shopify_product.options.first.try(:name)||''
    attr['Option1Value'] = shopify_product.options.first.try(:values).try(:first)||''
    attr['Regular_Price'] = '$'+variant.price
    attr['Sale_Price'] = '$'+variant.price
    # attr['Design_Code'] = data['tag']
    # attr['Partnership'] = data['note']
    attr['Supplier'] = metafields.select{|s| s.key == 'company'}.first.try(:value)||''
    attr['Supplier_BarCode'] = metafields.select{|s| s.key == 'supplier_barcode'}.first.try(:value)||''
    attr['Stretchability'] = (metafields.select{|s| s.key == 'stretchability'}.first.try(:value)||'').present?
    self.update(attr)
  end
end
