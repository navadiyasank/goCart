# frozen_string_literal: true

class HomeController < AuthenticatedController
	before_action :set_current_shop
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end

  def dashboard
  	
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

  private
  	# Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:status)
    end

  	def set_current_shop
      # @current_shop = ShopifyAPI::Shop.current
      # @shop = Shop.find_by_shopify_domain(ShopifyAPI::Shop.current.myshopify_domain)
      @shop = Shop.last
    end
end
