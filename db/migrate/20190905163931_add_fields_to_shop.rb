class AddFieldsToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :icon_type, :string, default: "cart"
    add_column :shops, :icon_color, :string, default: "#000000"
    add_column :shops, :icon_shape, :string, default: "circle"
  end
end
