class FrontendController < ApplicationController
	protect_from_forgery with: :null_session
	#Returns the go cart settings for specific shop
	def get_gocart_details
		@shop = Shop.find_by_shopify_domain(params[:shopify_domain])
		if @shop&.status
			render json: {is_active: true,msg: "success"} and return
		else
			render json: { msg: "No data found" } and return
		end
	end
end