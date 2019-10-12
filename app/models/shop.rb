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

  def asset_integrate1
    puts "<===================create snippet=================>"
    ShopifyAPI::Base.site = "https://#{ShopifyApp.configuration.api_key}:#{self.shopify_token}@#{self.shopify_domain}/admin/"
    ShopifyAPI::Base.api_version = ShopifyApp.configuration.api_version
    @theme = ShopifyAPI::Theme.find(:all).where(role: 'main').first
    @asset = ShopifyAPI::Asset.create(key: 'snippets/go-cart.liquid', value: "<script>
      function start(){
        window.loadScript = function(url, callback) {
          var script = document.createElement('script');
          script.type = 'text/javascript';
          // If the browser is Internet Explorer
          if (script.readyState){
            script.onreadystatechange = function() {
              if (script.readyState == 'loaded' || script.readyState == 'complete') {
                script.onreadystatechange = null;
                callback();
              }
            };
            // For any other browser
          } else {
            script.onload = function() {
              callback();
            };
          }
          script.src = url;
          document.getElementsByTagName('head')[0].appendChild(script);
        };

        window.goCartStart = function($) {
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
              var icon_color = data.color
              var icon_shape = data.shape
              var icon_type = data.icon_type
              console.log('response==',data);
              if(goCart_is_active){
                $( \"a[href='/cart']\" ).each(function( index ) {
                  height = $( this ).height();
                  b_class=$( this ).attr('class');
                  {% if cart.item_count > 0 %}
                    cart_image = {{ cart.items.last.image | json }}
                  {% endif %}
                  if(icon_type == 'cart'){
                    str_svg = \"<svg fill='\"+icon_color+\"' version='1.1' id='Layer_1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' viewBox='79 -79 670 670' style='enable-background:new 79 -79 670 670;' xml:space='preserve'><g id='XMLID_85_'><g id='XMLID_86_'><path id='XMLID_87_' class='st0' d='M724,171c-4.6-5.9-11.6-9.3-19.1-9.3h-465L218,70.3c-2.6-10.9-12.4-18.6-23.6-18.6h-80.1 C100.9,51.7,90,62.6,90,76s10.9,24.3,24.3,24.3h61l78.9,330.2c2.6,10.9,12.4,18.6,23.6,18.6h368c11.2,0,20.9-7.6,23.6-18.4 l59.1-238.8C730.2,184.6,728.6,176.9,724,171z M626.8,400.5H296.9l-45.5-190.2h422.3L626.8,400.5z'/></g></g><circle id='XMLID_84_' class='st0' cx='331.6' cy='512.9' r='48'/><circle id='XMLID_83_' class='st0' cx='596' cy='512.9' r='48'/></svg>\"
                  }else{
                    str_svg = \"<svg fill='\"+icon_color+\"' stroke='\"+icon_color+\"' stroke-width='20' stroke-miterlimit='10' version='1.1' id='Layer_1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' viewBox='0 0 600 600' style='enable-background:new 0 0 600 600;' xml:space='preserve'> <path id='XMLID_41_' class='st0' d='M490.2,131.6h-76.9v2.5c0-59.8-48.5-108.2-108.2-108.2c-59.8,0-108.2,48.5-108.2,108.2v-2.5 h-83.3c-6.9,0-12.4,5.6-12.5,12.5v363.9c0,34.4,27.9,62.3,62.3,62.3h277c34.4,0,62.3-27.9,62.3-62.3V144.1 C502.7,137.2,497.1,131.6,490.2,131.6z M221.7,133.9c0-46,37.3-83.3,83.3-83.3c46,0,83.3,37.3,83.3,83.3v-2.5H221.7V133.9z M477.7,507.9c-0.1,20.6-16.8,37.3-37.4,37.4h-277c-20.6-0.1-37.3-16.8-37.4-37.4V156.5h70.8v50.7c0,6.9,5.6,12.5,12.5,12.5 c6.9,0,12.5-5.6,12.5-12.5v-50.7h166.7v50.7c0,6.9,5.6,12.5,12.5,12.5c6.9,0,12.5-5.6,12.5-12.5v-50.7h64.5V507.9z'/> </svg>\"
                  }
                
                $( this ).replaceWith(\"<div class='go-cart-icon go-\"+icon_type+\" \"+icon_shape+\"'><a href='/cart' class='\"+b_class+\"'>\"+str_svg+\"{% if cart.item_count > 0 %}<img class='go-cart-item' src='\"+cart_image+\"' alt='cart' style='border-color:\"+icon_color+\";'><div id='CartCount' class='site-header__cart-count'><span>{{ cart.item_count }}</span><span class='icon__fallback-text medium-up--hide'>{{ 'layout.cart.items_count' | t: count: cart.item_count }}</span></div>{% endif %}</div></a>\")
                });
              }
            }
          });
        }
      }

      start();

      if (typeof window.appton !== 'undefined'){
        console.log(\"Jquery version==>\",jQuery.fn.jquery);
          loadScript('https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js', function() {
            jQuery340 = jQuery.noConflict(true);
            goCartStart(jQuery340);
          });
      }else{
        loadScript('https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js', function() {
          jQuery340 = jQuery.noConflict(true);
          goCartStart(jQuery340);
        });
      }
      </script>
      <style>
        .site-header__cart-count {
          display: flex;
          align-items: center;
          justify-content: center;
          position: absolute;
          right: 0.4rem;
          top: 0.2rem;
          font-weight: bold;
          background-color: #557b97;
          color: #fff;
          border-radius: 50%;
          min-width: 1em;
          height: 1em;
        }
        .go-cart .site-header__cart-count {
          right: 4px;
          top: -17px;
        }
        .go-cart.circle .site-header__cart-count {
          top: -15px;
        }
        .go-bag .site-header__cart-count {
          right: 6px;
          top: -13px;
        }
        .visually-hidden, .icon__fallback-text {
          position: absolute !important;
          overflow: hidden;
          clip: rect(0 0 0 0);
          height: 1px;
          width: 1px;
          margin: -1px;
          padding: 0;
          border: 0;
        }
        .site-header__cart, .site-header__search, .site-header__account {
          position: relative;
        }
        .site-header__cart-count span {
          font-family: 'HelveticaNeue','Helvetica Neue',Helvetica,Arial,sans-serif;
          font-size: calc(11em / 16);
          line-height: 1;
        }
        .go-cart-icon {
          position: relative;
        }
        .circle img.go-cart-item {
          width: 20px;
          height: 20px;
          position: absolute;
          border-radius: 50%;
          border-style: solid;
          border-width: 2px;
          top: -6px;
          right: 16px;
        }
        .go-bag.circle img.go-cart-item{
          top: 2px;
          right: 19px;
        }
        .go-cart-icon svg {
          height: auto;
          width: 30px;
        }
        .go-bag.go-cart-icon svg{
          width: 32px;
        }
        .rectangle img.go-cart-item{
          width: 18px;
          height: 20px;
          position: absolute;
          border-style: solid;
          border-width: 2px;
          top: -6px;
          right: 17px;
        }
        .go-bag.rectangle img.go-cart-item {
          width: 15px;
          height: 17px;
          top: 3px;
          right: 22px;
        }
        
        @media only screen and (max-width: 767px){
          .go-cart-icon{
            margin-top: 5px;
          }
          .go-cart-icon svg{
            height: 43px;
          }
          .go-bag.go-cart-icon svg{
            width: 33px;
          }
          .site-header__icon {
            display: inline-block;
            vertical-align: middle;
            padding: 5px 11px 10px 10px;
            margin: 0;
            font-size: 1em;
          }
          .circle img.go-cart-item {
            top: 10px;
            right: 14px;
          }
          .go-bag.circle img.go-cart-item{
            top: 20px;
            right: 17px;
          }
          .go-cart.rectangle .site-header__cart-count {
            right: 1px;
            top: 0px;
          }
          .go-cart.circle .site-header__cart-count {
            top: 0px;
          }
          .go-bag .site-header__cart-count {
            right: 3px;
            top: 4px;
          }
          .rectangle img.go-cart-item {
            top: 11px;
            right: 15px;
          }
          .go-bag.rectangle img.go-cart-item {
            top: 21px;
            right: 20px;
          }
        }
      </style>

    ", theme_id: @theme.id) rescue nil

    @asset = ShopifyAPI::Asset.find('layout/theme.liquid', :params => { :theme_id => @theme.id}) rescue nil
    if @asset.present?
      @asset_value = @asset.value
      @asset.update_attributes(theme_id: @theme.id,value: @asset_value.gsub("</body>","{% comment %}This is from goCart.{% endcomment %}{% include 'go-cart' %}</body>")) unless @asset_value.include?("{% include 'go-cart' %}")
    end
  end

  #this will creates snippet in current theme and include snippet in theme.liquid
  def asset_integrate
  	puts "<===================create snippet=================>"
  	ShopifyAPI::Base.site = "https://#{ShopifyApp.configuration.api_key}:#{self.shopify_token}@#{self.shopify_domain}/admin/"
    ShopifyAPI::Base.api_version = ShopifyApp.configuration.api_version
    @theme = ShopifyAPI::Theme.find(:all).where(role: 'main').first
    @asset = ShopifyAPI::Asset.create(key: 'snippets/go-cart.liquid', value: "<script>
      function start(){
        window.loadScript = function(url, callback) {
          var script = document.createElement('script');
          script.type = 'text/javascript';
          // If the browser is Internet Explorer
          if (script.readyState){
            script.onreadystatechange = function() {
              if (script.readyState == 'loaded' || script.readyState == 'complete') {
                script.onreadystatechange = null;
                callback();
              }
            };
            // For any other browser
          } else {
            script.onload = function() {
              callback();
            };
          }
          script.src = url;
          document.getElementsByTagName('head')[0].appendChild(script);
        };

        window.goCartStart = function($) {
          window.goCart = {
            shopify_domain: '{{shop.permanent_domain}}',
            app_url: '#{ENV['DOMAIN']}',
          }
          $( \"a[href='/cart'] span\" ).css('animation', 'select-icon 1.5s linear infinite')
        }
      }

      start();

      if (typeof window.appton !== 'undefined'){
        console.log(\"Jquery version==>\",jQuery.fn.jquery);
          loadScript('https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js', function() {
            jQuery340 = jQuery.noConflict(true);
            goCartStart(jQuery340);
          });
      }else{
        loadScript('https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js', function() {
          jQuery340 = jQuery.noConflict(true);
          goCartStart(jQuery340);
        });
      }
      </script>
      <style>
        @-webkit-keyframes select-icon {
          0% {
            -webkit-box-shadow: 0 0 0 0 rgba(239,115,115, 0.7);
          }
          70% {
              -webkit-box-shadow: 0 0 0 10px rgba(239,215,215, 0);
          }
          100% {
              -webkit-box-shadow: 0 0 0 0 rgba(239,215,215, 0);
          }
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
