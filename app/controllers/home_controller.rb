# frozen_string_literal: true

class HomeController < AuthenticatedController
# class HomeController < ApplicationController
	before_action :set_current_shop
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end

  def dashboard
  	@blink_speed = @shop.blink_speed
    @blink_color = @shop.blink_color
    @blink_width = @shop.blink_wider
  end

  def update_shop
  	respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to root_path, notice: 'App status was successfully updated.' }
      else
        format.html { render :dashboard }
      end
    end
  end

  def update_advanced_features
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to root_path, notice: 'App status was successfully updated.' }
      else
        format.html { render :dashboard }
      end
    end
  end

  def change_settings
    @blink_speed = params[:blink_speed]
    @blink_color = params[:blink_color]
    @blink_width = params[:blink_width]
  end

  def faq_page
  end

  def contact_us
  end

  private
  	# Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:status,:icon_color,:icon_shape,:icon_type,:blink_speed,:blink_color,:blink_wider,:cart_title_text,:title_animation_type,:cart_title_text,:no_cart_title_text)
    end

  	def set_current_shop
      @current_shop = ShopifyAPI::Shop.current
      @shop = Shop.find_by_shopify_domain(ShopifyAPI::Shop.current.myshopify_domain)
      # @shop = Shop.last
    end
end
