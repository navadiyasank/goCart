class ShopUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
			if ['partner_test','affiliate','staff_business'].include? shop.shopify_plan_name && shop.shopify_plan_name != webhook['plan_name']
				shop.update(is_paid: false, shopify_plan_name: webhook['plan_name'])
			end
    end
  end
end
