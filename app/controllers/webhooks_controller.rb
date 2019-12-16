# frozen_string_literal: true

class WebhooksController < ApplicationController

  # include ShopifyApp::WebhookVerification
  skip_before_action :verify_authenticity_token

  def customer_create
    puts "**************customer_create***************"
    puts params.inspect
    puts "*********************************************"
    customer_profile = CustomerProfile.find_by_Email(params[:email])
    if customer_profile.blank?
      CustomerProfile.data_insert(params)
    else
      customer_profile.data_update(params)
    end
    head :no_content
  end

  def customer_update
    puts "**************customer_update***************"
    puts params.inspect
    puts "*********************************************"
    customer_profile = CustomerProfile.find_by_Email(params[:email])
    if customer_profile.blank?
      CustomerProfile.data_insert(params)
    else
      customer_profile.data_update(params)
    end
    head :no_content
  end

  def order_create
    puts "**************order_create***************"
    puts params.inspect
    puts "*********************************************"
    params[:line_items].each do |line_item|
      customer_order = CustomerOrder.where('Name' => params['name'], 'Id' => line_item[:id]).first
      if customer_order.blank?
        CustomerOrder.data_insert(params, line_item[:id])
      else
        customer_order.data_update(params, line_item[:id])
      end
    end
    head :no_content
  end

  def order_update
    puts "**************order_create***************"
    puts params.inspect
    puts "*********************************************"
    params[:line_items].each do |line_item|
      customer_order = CustomerOrder.where('shopify_order_id' => params[:id], 'shopify_line_item_id' => line_item[:id]).first
      if customer_order.blank?
        CustomerOrder.data_insert(params, line_item[:id])
      else
        customer_order.data_update(params, line_item[:id])
      end
    end
    head :no_content
  end

  def product_create
    puts "**************product_create***************"
    puts params.inspect
    puts "*********************************************"
    product = Product.find_by_ProductSKU(params['variants'].first['sku'])
    if product.blank?
      Product.data_insert(params)
    else
      product.data_update(params)
    end
    head :no_content
  end

  def product_update
    puts "**************product_update***************"
    puts params.inspect
    puts "*********************************************"
    product = Product.find_by_ProductSKU(params[:variants].first['sku'])
    if product.blank?
      Product.data_insert(params)
    else
      product.data_update(params)
    end
    head :no_content
  end
end
