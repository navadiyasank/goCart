class AddTitleTextAndTitleAnimationTypeToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :title_text, :string,default: "{{cart_items}} items missing"
    add_column :shops, :title_animation_type, :string,default: "blink"
    add_column :shops, :is_paid, :boolean
    add_column :shops, :is_advance, :boolean
  end
end