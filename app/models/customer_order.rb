class CustomerOrder < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Customer_orders"

  def self.data_insert(data, line_item_id)
    Shop.first.set_store_session
    shopify_order = ShopifyAPI::Order.find(data['id'])
    line_item = shopify_order.line_items.select{|s| s.id == line_item_id}.first
    attr = {} 
    attr["shopify_order_id"] = shopify_order.id
    attr["shopify_line_item_id"] = line_item.id
    attr["Name"] = shopify_order.name
    attr["Email"] = shopify_order.email
    attr["Financial Status"] = shopify_order.financial_status
    attr["Paid at"] = shopify_order.processed_at
    attr["Fulfillment Status"] = shopify_order.fulfillment_status
    attr["Fulfilled at"] = shopify_order.fulfillments.first.try(:created_at)||''
    attr["Accepts Marketing"] = shopify_order.buyer_accepts_marketing
    attr["Currency"] = shopify_order.currency
    attr["Subtotal"] = shopify_order.subtotal_price
    attr["Shipping"] = shopify_order.shipping_lines.map(&:price).sum
    attr["Taxes"] = shopify_order.total_tax
    attr["Total"] = shopify_order.total_price
    # attr["Discount Code"] = shopify_order
    attr["Discount Amount"] = shopify_order.total_discounts
    attr["Shipping Method"] = shopify_order.shipping_lines.map(&:title).join(',')
    attr["Created at"] = shopify_order.created_at
    attr["Lineitem quantity"] = line_item.quantity
    attr["Lineitem name"] = line_item.name
    attr["Lineitem price"] = line_item.price
    # attr["Lineitem compare at price"] = shopify_order
    attr["Lineitem sku"] = line_item.sku
    attr["Lineitem requires shipping"] = line_item.requires_shipping
    attr["Lineitem taxable"] = line_item.taxable
    attr["Lineitem fulfillment status"] = shopify_order.fulfillment_status
    attr["Billing Name"] = shopify_order.billing_address.first_name
    # attr["Billing Street"] = shopify_order
    attr["Billing Address1"] = shopify_order.billing_address.address1
    attr["Billing Address2"] = shopify_order.billing_address.address2
    attr["Billing Company"] = shopify_order.billing_address.company
    attr["Billing City"] = shopify_order.billing_address.city
    attr["Billing Zip"] = shopify_order.billing_address.zip
    attr["Billing Province"] = shopify_order.billing_address.province
    attr["Billing Country"] = shopify_order.billing_address.country
    attr["Billing Phone"] = shopify_order.billing_address.phone

    attr["Shipping Name"] = shopify_order.shipping_address.first_name
    # attr["Shipping Street"] = shopify_order.shipping_address
    attr["Shipping Address1"] = shopify_order.shipping_address.address1
    attr["Shipping Address2"] = shopify_order.shipping_address.address2
    attr["Shipping Company"] = shopify_order.shipping_address.company
    attr["Shipping City"] = shopify_order.shipping_address.city
    attr["Shipping Zip"] = shopify_order.shipping_address.zip
    attr["Shipping Province"] = shopify_order.shipping_address.province
    attr["Shipping Country"] = shopify_order.shipping_address.country
    attr["Shipping Phone"] = shopify_order.shipping_address.phone
    attr["Notes"] = shopify_order.note
    attr["Note Attributes"] = shopify_order.note_attributes.map{|s| "#{s.name}:#{s.value}"}.join(',')
    attr["Cancelled at"] = shopify_order.cancelled_at
    attr["Payment Method"] = shopify_order.payment_gateway_names.join(', ')
    # attr["Payment Reference"] = shopify_order
    attr["Refunded Amount"] = shopify_order.refunds.map{|s| s.order_adjustments.map(&:amount).sum}.flatten.sum
    # attr["Vendor"] = line_item.product.vendor
    attr["Tags"] = shopify_order.tags
    # attr["Risk Level"] = shopify_order.order_risk.source
    attr["Source"] = shopify_order.source_name
    attr["Lineitem discount"] = line_item.total_discount
    attr["Phone"] = shopify_order.phone
    shopify_order.tax_lines.each_with_index do |tax_line, index|
      attr["Tax #{index+1} Name"] = tax_line.title
      attr["Tax #{index+1} Value"] = tax_line.price
    end
    CustomerOrder.create(attr)
    
    # attr["Receipt Number"] => shopify_order
  end
    
  def data_update(data, line_item_id)
    Shop.first.set_store_session
    shopify_order = ShopifyAPI::Order.find(data['id'])
    line_item = shopify_order.line_items.select{|s| s.id == line_item_id}.first
    attr = {} 
    attr["shopify_order_id"] = shopify_order.id
    attr["shopify_line_item_id"] = line_item.id
    attr["Name"] = shopify_order.name
    attr["Email"] = shopify_order.email
    attr["Financial Status"] = shopify_order.financial_status
    attr["Paid at"] = shopify_order.processed_at
    attr["Fulfillment Status"] = shopify_order.fulfillment_status
    attr["Fulfilled at"] = shopify_order.fulfillments.first.try(:created_at)||''
    attr["Accepts Marketing"] = shopify_order.buyer_accepts_marketing
    attr["Currency"] = shopify_order.currency
    attr["Subtotal"] = shopify_order.subtotal_price
    attr["Shipping"] = shopify_order.shipping_lines.map(&:price).sum
    attr["Taxes"] = shopify_order.total_tax
    attr["Total"] = shopify_order.total_price
    # attr["Discount Code"] = shopify_order
    attr["Discount Amount"] = shopify_order.total_discounts
    attr["Shipping Method"] = shopify_order.shipping_lines.map(&:title).join(',')
    attr["Created at"] = shopify_order.created_at
    attr["Lineitem quantity"] = line_item.quantity
    attr["Lineitem name"] = line_item.name
    attr["Lineitem price"] = line_item.price
    # attr["Lineitem compare at price"] = shopify_order
    attr["Lineitem sku"] = line_item.sku
    attr["Lineitem requires shipping"] = line_item.requires_shipping
    attr["Lineitem taxable"] = line_item.taxable
    attr["Lineitem fulfillment status"] = shopify_order.fulfillment_status
    attr["Billing Name"] = shopify_order.billing_address.first_name
    # attr["Billing Street"] = shopify_order
    attr["Billing Address1"] = shopify_order.billing_address.address1
    attr["Billing Address2"] = shopify_order.billing_address.address2
    attr["Billing Company"] = shopify_order.billing_address.company
    attr["Billing City"] = shopify_order.billing_address.city
    attr["Billing Zip"] = shopify_order.billing_address.zip
    attr["Billing Province"] = shopify_order.billing_address.province
    attr["Billing Country"] = shopify_order.billing_address.country
    attr["Billing Phone"] = shopify_order.billing_address.phone

    attr["Shipping Name"] = shopify_order.shipping_address.first_name
    # attr["Shipping Street"] = shopify_order.shipping_address
    attr["Shipping Address1"] = shopify_order.shipping_address.address1
    attr["Shipping Address2"] = shopify_order.shipping_address.address2
    attr["Shipping Company"] = shopify_order.shipping_address.company
    attr["Shipping City"] = shopify_order.shipping_address.city
    attr["Shipping Zip"] = shopify_order.shipping_address.zip
    attr["Shipping Province"] = shopify_order.shipping_address.province
    attr["Shipping Country"] = shopify_order.shipping_address.country
    attr["Shipping Phone"] = shopify_order.shipping_address.phone
    attr["Notes"] = shopify_order.note
    attr["Note Attributes"] = shopify_order.note_attributes.map{|s| "#{s.name}:#{s.value}"}.join(',')
    attr["Cancelled at"] = shopify_order.cancelled_at
    attr["Payment Method"] = shopify_order.payment_gateway_names.join(', ')
    # attr["Payment Reference"] = shopify_order
    attr["Refunded Amount"] = shopify_order.refunds.map{|s| s.order_adjustments.map(&:amount).sum}.flatten.sum
    # attr["Vendor"] = line_item.product.vendor
    attr["Tags"] = shopify_order.tags
    # attr["Risk Level"] = shopify_order.order_risk.source
    attr["Source"] = shopify_order.source_name
    attr["Lineitem discount"] = line_item.total_discount
    attr["Phone"] = shopify_order.phone
    shopify_order.tax_lines.each_with_index do |tax_line, index|
      attr["Tax #{index+1} Name"] = tax_line.title
      attr["Tax #{index+1} Value"] = tax_line.price
    end
    self.update(attr)
  end
end
