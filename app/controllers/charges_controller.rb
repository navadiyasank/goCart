class ChargesController < ShopifyApp::AuthenticatedController
	before_action :set_shop

	def create_charge
		if @shop && !@shop.is_paid
			puts "plan_name===>#{@shop.shopify_plan_name}"
			if ['partner_test','affiliate','staff_business'].include? @shop.shopify_plan_name
				puts "Innnnnn"
				@shop.update(is_paid: true)
			else
				current_charge = ShopifyAPI::RecurringApplicationCharge.current
				if current_charge
					puts "current charge"
					@shop.update(is_paid: true, charge_id: current_charge.id)
				else 
					puts "else"
					allcharge = ShopifyAPI::RecurringApplicationCharge.all rescue nil
					if allcharge.present?
						allcharge.each do |charge|
							@redirect_charge = charge.confirmation_url if charge.status == 'pending'
						end
					end

					unless @redirect_charge.present?
						recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new( name: "Pro Plan", price: 2.99, return_url: "#{ENV['DOMAIN']}/charges/activate_charge", test: true)

						if recurring_application_charge.save
							puts "recurring_application_charge : #{recurring_application_charge.to_json}"
							puts "recurring_application_charge URl : #{recurring_application_charge.confirmation_url}"
							@redirect_charge = recurring_application_charge.confirmation_url
						end
					end
				end
			end
		end

		unless @redirect_charge.present?
			@redirect_charge = root_path
		end

		fullpage_redirect_to(@redirect_charge)
	end

	def activate_charge
		recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(request.params['charge_id'])
		if @shop.present?
			if recurring_application_charge.status == "accepted"
				recurring_application_charge.activate
				@shop.update(is_paid: true, charge_id: request.params['charge_id'], charge_date: recurring_application_charge.created_at)
			else
				@shop.update(is_paid: false, charge_id: nil, charge_date: nil)
			end
		end
		redirect_to root_path, notice: 'Charge is successfully activated'
	end

	def deactivate_charge
		if (@shop && @shop.is_paid && @shop.charge_id.present?) || ['partner_test','affiliate','staff_business'].include?(@shop.shopify_plan_name)
			begin
				recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current rescue nil
				if recurring_application_charge
					recurring_application_charge.cancel
				end
			rescue Exception => e
				puts e.to_s
			end
			@shop.update(is_paid: false, charge_id: nil, charge_date: nil)
		end
		redirect_to root_path, notice: 'Charge is successfully deactivated.'
	end

	private
    def set_shop
      @current_store = ShopifyAPI::Shop.current
      @shop = Shop.find_by_shopify_domain(@current_store.myshopify_domain)
    end
end
