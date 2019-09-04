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
              str_svg = \"<svg fill='#010101' version='1.1' id='Layer_1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' viewBox='79 -79 670 670' style='enable-background:new 79 -79 670 670;' xml:space='preserve'><g id='XMLID_85_'><g id='XMLID_86_'><path id='XMLID_87_' class='st0' d='M724,171c-4.6-5.9-11.6-9.3-19.1-9.3h-465L218,70.3c-2.6-10.9-12.4-18.6-23.6-18.6h-80.1 C100.9,51.7,90,62.6,90,76s10.9,24.3,24.3,24.3h61l78.9,330.2c2.6,10.9,12.4,18.6,23.6,18.6h368c11.2,0,20.9-7.6,23.6-18.4 l59.1-238.8C730.2,184.6,728.6,176.9,724,171z M626.8,400.5H296.9l-45.5-190.2h422.3L626.8,400.5z'/></g></g><circle id='XMLID_84_' class='st0' cx='331.6' cy='512.9' r='48'/><circle id='XMLID_83_' class='st0' cx='596' cy='512.9' r='48'/></svg>\"
              $( this ).replaceWith(\"<div class='go-cart-icon'><a href='/cart' class='\"+b_class+\"'>\"+str_svg+\"{% if cart.item_count > 0 %}<img class='go-cart-item' src='\"+cart_image+\"' alt='cart'><div id='CartCount' class='site-header__cart-count'><span>{{ cart.item_count }}</span><span class='icon__fallback-text medium-up--hide'>{{ 'layout.cart.items_count' | t: count: cart.item_count }}</span></div>{% endif %}</div></a>\")
              });
            }
          }
        });
        
      </script>
      <style>
        .go-cart-icon {
          position: relative;
        }
        img.go-cart-item {
          width: 20px;
          height: 20px;
          position: absolute;
          border-radius: 50%;
          border: 2px solid black;
          top: -9px;
          right: 15px;
        }
        .site-header__icon svg {
            height: auto;
          width: 30px;
        }
        .site-header__cart-count {
          right: 3px;
          top: -15px;
        }
      </style>

    ", theme_id: @theme.id) rescue nil

    @asset = ShopifyAPI::Asset.find('layout/theme.liquid', :params => { :theme_id => @theme.id}) rescue nil
    if @asset.present?
      @asset_value = @asset.value
      @asset.update_attributes(theme_id: @theme.id,value: @asset_value.gsub("</body>","{% comment %}This is from goCart.{% endcomment %}{% include 'go-cart' %}</body>")) unless @asset_value.include?("{% include 'go-cart' %}")
    end
  end
end
