class FrontendController < ApplicationController
	protect_from_forgery with: :null_session
	#Returns the go cart settings for specific shop
	def get_gocart_details
		@shop = Shop.find_by_shopify_domain(params[:shopify_domain])
		if @shop&.status
			# render json: {is_active: true, shape: @shop.icon_shape, color: @shop.icon_color, icon_type: @shop.icon_type,msg: "success"} and return
			response_json = {is_active: true,msg: "success",blink_speed: @shop.blink_speed,is_advance: @shop.is_advance}
			if @shop.is_advance
				response_json[:title_text] = params[:cart_items].to_i > 0 ? @shop.cart_title_text : @shop.no_cart_title_text
				response_json[:title_animation_type] = @shop.title_animation_type
			end
			render json: response_json and return
		else
			render json: { msg: "No data found" } and return
		end
	end
end