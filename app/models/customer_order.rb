class CustomerOrder < ActiveRecord::Base

  validates :shopify_line_item_id, uniqueness: true

  establish_connection(:secondary)
  self.table_name = "Customer_orders"

  def self.data_insert(data, line_item_id)
    Shop.first.set_store_session
    shopify_order = ShopifyAPI::Order.find(data['id'])
    line_item = shopify_order.line_items.select{|s| s.id == line_item_id}.first
    shipping_address = shopify_order.shipping_address rescue nil
    billing_address = shopify_order.billing_address rescue nil
    billing_address = shipping_address if billing_address.blank?

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
    if billing_address.present?
        attr["Billing Name"] = billing_address.first_name
        # attr["Billing Street"] = shopify_order
        attr["Billing Address1"] = billing_address.address1
        attr["Billing Address2"] = billing_address.address2
        attr["Billing Company"] = billing_address.company
        attr["Billing City"] = billing_address.city
        attr["Billing Zip"] = billing_address.zip
        attr["Billing Province"] = billing_address.province
        attr["Billing Country"] = billing_address.country
        attr["Billing Phone"] = billing_address.phone
    end
    if shipping_address.present?
        attr["Shipping Name"] = shipping_address.first_name
        # attr["Shipping Street"] = shipping_address
        attr["Shipping Address1"] = shipping_address.address1
        attr["Shipping Address2"] = shipping_address.address2
        attr["Shipping Company"] = shipping_address.company
        attr["Shipping City"] = shipping_address.city
        attr["Shipping Zip"] = shipping_address.zip
        attr["Shipping Province"] = shipping_address.province
        attr["Shipping Country"] = shipping_address.country
        attr["Shipping Phone"] = shipping_address.phone
    end
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
    CustomerOrder.update_inventory(shopify_order, line_item)
  end
    
  def data_update(data, line_item_id)
    Shop.first.set_store_session
    shopify_order = ShopifyAPI::Order.find(data['id'])
    line_item = shopify_order.line_items.select{|s| s.id == line_item_id}.first
    shipping_address = shopify_order.shipping_address rescue nil
    billing_address = shopify_order.billing_address rescue nil
    billing_address = shipping_address if billing_address.blank?
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
    if billing_address.present?
        attr["Billing Name"] = billing_address.first_name
        # attr["Billing Street"] = shopify_order
        attr["Billing Address1"] = billing_address.address1
        attr["Billing Address2"] = billing_address.address2
        attr["Billing Company"] = billing_address.company
        attr["Billing City"] = billing_address.city
        attr["Billing Zip"] = billing_address.zip
        attr["Billing Province"] = billing_address.province
        attr["Billing Country"] = billing_address.country
        attr["Billing Phone"] = billing_address.phone
    end
    if shipping_address.present?
        attr["Shipping Name"] = shipping_address.first_name
        # attr["Shipping Street"] = shipping_address
        attr["Shipping Address1"] = shipping_address.address1
        attr["Shipping Address2"] = shipping_address.address2
        attr["Shipping Company"] = shipping_address.company
        attr["Shipping City"] = shipping_address.city
        attr["Shipping Zip"] = shipping_address.zip
        attr["Shipping Province"] = shipping_address.province
        attr["Shipping Country"] = shipping_address.country
        attr["Shipping Phone"] = shipping_address.phone
    end
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
    CustomerOrder.update_inventory(shopify_order, line_item)
    # if shopify_order.cancelled_at.present?
    #     quantity = line_item.quantity
    # else
    #     quantity = (-1*line_item.quantity)
    # end
    # variant_sub_sku = line_item.properties.select{|s| s.name == '_product_subsku_short'}.first.try(:value)
    # variant_sub_sku = line_item.sku if variant_sub_sku.blank?
    # order_name = shopify_order.name
    # InventoryOut.update_inventory(shopify_order.id, line_item.id, variant_sub_sku, order_name, line_item.quantity)
  end

  def self.update_inventory(shopify_order, line_item)
    variant_sub_sku = line_item.properties.select{|s| s.name == '_product_subsku_short'}.first.try(:value)
    if variant_sub_sku.blank?
        CustomerLogin.data_insert(shopify_order.customer.id)
        customer_skus = CustomerProduct.find_shopify_variant_id(shopify_order.email)
        puts "************Customer SKUS**********"
        puts customer_skus.inspect
        puts "**********************************"
        count = 0
        while customer_skus.blank? && count < 3
          count = count + 1
          sleep 2
          customer_skus = CustomerProduct.find_shopify_variant_id(shopify_order.email)
        end
        if customer_skus.present?
            variant_sub_sku = customer_skus[line_item.variant_id.to_s]
        end
        variant_sub_sku = line_item.sku if variant_sub_sku.blank?
    end
    order_name = shopify_order.name
    quantity = (-1*line_item.quantity)
    InventoryOut.update_inventory(shopify_order.id, line_item.id, variant_sub_sku, order_name, quantity, shopify_order.cancelled_at.present?)
  end
end
