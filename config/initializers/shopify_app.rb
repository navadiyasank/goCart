ShopifyApp.configure do |config|
  config.application_name = "Go Cart App"
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_API_SECRET']
  config.old_secret = ""
  config.scope = "write_themes" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2019-10"
  config.session_repository = Shop
  config.webhooks = [
    {topic: 'shop/update', address: "#{ENV['DOMAIN']}/webhooks/shop_update", format: 'json'},
  ]
end
