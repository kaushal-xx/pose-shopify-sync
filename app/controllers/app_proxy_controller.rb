class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    render layout: false, content_type: 'application/liquid'
  end

  def set_login
    if params[:cid].present?
      email = CustomerLogin.data_insert(params[:cid]) 
      objects = CustomerProduct.find_shopify_variant_id(email)
      render json: {shopify_variant_id: objects.keys, shopify_product_mapping: objects}
    else
      render json: {shopify_variant_id: [], shopify_product_mapping: {}}
    end
  end

  def set_logout
    CustomerLogin.data_delete(params[:cid]) if params[:cid].present?
    render json: {'message' => 'Data Updated'}
  end

  def update_script

  end

end
