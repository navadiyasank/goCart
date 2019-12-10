class AddTitleTextAndTitleAnimationTypeToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :cart_title_text, :string,default: "💥 You have {cart_items} items in your cart."
    add_column :shops, :no_cart_title_text, :string,default: "⚡️ Secret Sale ⚡️ Save 20% Off"
    add_column :shops, :title_animation_type, :string,default: "blink"
    add_column :shops, :is_paid, :boolean
    add_column :shops, :is_advance, :boolean
  end
end
