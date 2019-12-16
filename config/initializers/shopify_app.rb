ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.scope = "read_script_tags, write_script_tags, read_products,read_product_listings,read_customers,read_orders,read_draft_orders,read_inventory,read_locations,read_fulfillments,read_shipping,read_checkouts,read_price_rules,read_discounts, read_themes, write_themes" # Consult this page for more scope options:
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = ""
  config.session_repository = Shop
  config.api_version = '2019-10'
  config.webhooks = [
    {topic: 'customers/create', address: "https://pose-shopify-sync.herokuapp.com/customer_create", format: "json"},
    {topic: 'customers/update', address: "https://pose-shopify-sync.herokuapp.com/customer_update", format: "json"},
    {topic: 'orders/create', address: "https://pose-shopify-sync.herokuapp.com/order_create", format: "json"},
    {topic: 'orders/updated', address: "https://pose-shopify-sync.herokuapp.com/order_update", format: "json"},
    {topic: 'products/create', address: "https://pose-shopify-sync.herokuapp.com/product_create", format: "json"},
    {topic: 'products/update', address: "https://pose-shopify-sync.herokuapp.com/product_update", format: "json"}
  ]
  config.scripttags = [
    {event:'onload', src: "https://pose-shopify-sync.herokuapp.com/user_session.js", format: "script"}
  ]
end
