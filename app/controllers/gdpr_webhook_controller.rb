class GdprWebhookController < ApplicationController

	def customers_redact
		render plain: "We didn't store any customers data" and return
  end

  def shop_redact
  	@shop = Shop.find_by(shopify_domain: params['shop_domain'])
  	@shop.destroy if @shop.present?
		render plain: "Shop data has been destroyed" and return
  end

  def customers_data_request
  	render plain: "We didn't store any customers data" and return
  end
end