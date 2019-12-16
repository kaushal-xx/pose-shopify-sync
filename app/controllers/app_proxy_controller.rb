class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    render layout: false, content_type: 'application/liquid'
  end

  def set_login
    if params[:cid].present?
      email = CustomerLogin.data_insert(params[:cid]) 
      render json: {product_sku: CustomerProduct.find_product_sku(email)}
    else
      render json: {product_sku: []}
    end
  end

  def set_logout
    CustomerLogin.data_delete(params[:cid]) if params[:cid].present?
    render json: {'message' => 'Data Updated'}
  end

end
