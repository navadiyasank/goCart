class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage
  after_create :set_configuration
  after_update :set_configuration, if: ->(obj){ obj.saved_change_to_shopify_token? }

  def api_version
    ShopifyApp.configuration.api_version
  end

  def set_configuration
    asset_integrate
  end

  #this will creates snippet in current theme and include snippet in theme.liquid
  def asset_integrate
  	puts "<===================create snippet=================>"
  	ShopifyAPI::Base.site = "https://#{ShopifyApp.configuration.api_key}:#{self.shopify_token}@#{self.shopify_domain}/admin/"
    ShopifyAPI::Base.api_version = ShopifyApp.configuration.api_version
    @theme = ShopifyAPI::Theme.find(:all).where(role: 'main').first
    @asset = ShopifyAPI::Asset.create(key: 'snippets/go-cart.liquid', value: "
      <script>
        window.goCart = {
          shopify_domain: '{{shop.permanent_domain}}',
          app_url: '#{ENV['DOMAIN']}',
        }
        $.ajax({
          type:'GET',
          url: window.goCart.app_url+'/frontend/get_gocart_details',
          data : {shopify_domain : window.goCart.shopify_domain},
          crossDomain: true,
          success:function(data){
            var goCart_is_active = data.is_active;
            console.log('response==',data);
            if(goCart_is_active){
              $( \"a[href='/cart']\" ).each(function( index ) {
                height = $( this ).height();
                b_class=$( this ).attr('class');
                {% if cart.item_count > 0 %}
                  cart_image = {{ cart.items.last.image | json }}
                {% else %}
                  cart_image = '#{ENV['DOMAIN']}/cart.svg'
                {% endif %}
              $( this ).replaceWith(\"<a href='/cart' class='\"+b_class+\"'><img src='\"+cart_image+\"' alt='cart' style='height:\"+height+\"px;'>{% if cart.item_count > 0 %}<div id='CartCount' class='site-header__cart-count'><span>{{ cart.item_count }}</span><span class='icon__fallback-text medium-up--hide'>{{ 'layout.cart.items_count' | t: count: cart.item_count }}</span></div>{% endif %}</a>\")
              });
            }
          }
        });
        
      </script>

    ", theme_id: @theme.id) rescue nil

    @asset = ShopifyAPI::Asset.find('layout/theme.liquid', :params => { :theme_id => @theme.id}) rescue nil
    if @asset.present?
      @asset_value = @asset.value
      @asset.update_attributes(theme_id: @theme.id,value: @asset_value.gsub("</body>","{% comment %}This is from goCart.{% endcomment %}{% include 'go-cart' %}</body>")) unless @asset_value.include?("{% include 'go-cart' %}")
    end
  end
end
